#!/usr/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Finetune on STS
python $SCRIPT_DIR/run_sts.py \
  --model_name_or_path "bsc/roberta-base-ca-cased" \
  --dataset_name "bsc/sts-ca" \
  --do_train \
  --do_eval \
  --do_predict \
  --per_device_train_batch_size 4 \
  --gradient_accumulation_steps 2 \
  --num_train_epochs 10 \
  --max_seq_length 512 \
  --load_best_model_at_end \
  --metric_for_best_model combined_score \
  --evaluation_strategy epoch \
  --seed 1 \
  --logging_dir "$SCRIPT_DIR/roberta-base-ca-cased-sts/tb" \
  --output_dir "$SCRIPT_DIR/roberta-base-ca-cased-sts"

