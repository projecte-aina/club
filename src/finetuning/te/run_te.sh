#!/usr/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Finetune on TECA
python $SCRIPT_DIR/run_te.py \
  --model_name_or_path "BSC-TeMU/roberta-base-ca" \
  --dataset_name "BSC-TeMU/teca" \
  --do_train \
  --do_eval \
  --do_predict \
  --per_device_train_batch_size 1 \
  --gradient_accumulation_steps 1 \
  --num_train_epochs 1 \
  --max_seq_length 128 \
  --load_best_model_at_end \
  --metric_for_best_model "accuracy" \
  --evaluation_strategy "steps" \
  --save_strategy "steps" \
  --save_steps 1 \
  --logging_steps 1 \
  --max_steps 3 \
  --seed 1 \
  --overwrite_output_dir \
  --logging_dir "$SCRIPT_DIR/roberta-base-ca-cased-te/tb" \
  --output_dir "$SCRIPT_DIR/roberta-base-ca-cased-te"

