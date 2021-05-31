#!/bin/bash
#SBATCH --nodes=4
#SBATCH --wait
#SBATCH --wait-all-nodes=1
#SBATCH --ntasks=16
#SBATCH --gres gpu:4
#SBATCH --cpus-per-task=40
#SBATCH --time=2-00:00:00

load_config() {
    module load gcc/8.3.0 cuda/10.2 cudnn/7.6.4 nccl/2.4.8 tensorrt/6.0.1 openmpi/4.0.1 atlas/3.10.3 scalapack/2.0.2 \
           fftw/3.3.8 szip/2.1.1 ffmpeg/4.2.1 opencv/4.1.1 python/3.7.4_ML
    source /gpfs/projects/bsc88/BERTs/venv/bin/activate
    MASTER_PORT=12358
}

fairseq_cmd() {
    # First argument ($1): Master IP
    # Second argument ($2): Number of nodes
    # Third argument ($3): Node rank/id (starting from 0, eg. master is 0)
    
    # Fairseq parameters
    DATA_DIR=data-bin
    TOTAL_UPDATES=125000    # Total number of training steps
    WARMUP_UPDATES=10000    # Warmup the learning rate over this many updates
    PEAK_LR=0.0005          # Peak learning rate, adjust as needed
    TOKENS_PER_SAMPLE=512   # Max sequence length
    MAX_POSITIONS=512       # Num. positional embeddings (usually same as above)
    MAX_SENTENCES=8        # Number of sequences per batch (batch size)
    UPDATE_FREQ=16          # Increase the batch size 16x
    echo $1 $2 $3
    python -m torch.distributed.launch --nproc_per_node=4 \
    --master_addr=$1 --master_port=$MASTER_PORT --nnodes=$2 --node_rank=$3 \
    $(which fairseq-train) --fp16 $DATA_DIR \
    --task masked_lm --criterion masked_lm \
    --arch roberta_base --sample-break-mode complete_doc --tokens-per-sample $TOKENS_PER_SAMPLE \
    --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
    --lr-scheduler polynomial_decay --lr $PEAK_LR --warmup-updates $WARMUP_UPDATES --total-num-update $TOTAL_UPDATES \
    --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
    --max-sentences $MAX_SENTENCES --update-freq $UPDATE_FREQ \
    --max-update $TOTAL_UPDATES --log-format simple --log-interval 1 \
    --distributed-no-spawn --tensorboard-logdir tb --skip-invalid-size-inputs-valid-test \
    --save-interval-updates 1000
}


load_config

fairseq_cmd localhost $SLURM_JOB_NUM_NODES 0 &

hostlist=$(scontrol show hostname $SLURM_JOB_NODELIST)
master=$(echo "${hostlist}" | head -n 1)
i=1
while [ $i -lt $SLURM_JOB_NUM_NODES ]
do
  j=$(($i + 1))
  host=$(echo "${hostlist}" | sed "${j}q;d")
  echo $master  ${SLURM_JOB_NUM_NODES} ${i}
  ssh -n "$host" "$(typeset -f load_config); $(typeset -f fairseq_cmd); cd ${SLURM_SUBMIT_DIR}; load_config; fairseq_cmd ${master} ${SLURM_JOB_NUM_NODES} ${i}" &
  ((i++))
done
