#!/usr/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

model_name=$1

# Finetune on Text Classification
python $SCRIPT_DIR/run_tc.py \
  --model_name_or_path ${model_name} \
  --dataset_name "projecte-aina/tecla" \
  --do_train \
  --do_eval \
  --do_predict \
  --per_device_train_batch_size 4 \
  --gradient_accumulation_steps 2 \
  --num_train_epochs 10 \
  --max_seq_length 512 \
  --load_best_model_at_end \
  --metric_for_best_model accuracy \
  --evaluation_strategy epoch \
  --save_strategy epoch \
  --seed 1 \
  --logging_dir "$SCRIPT_DIR/${model_name}-tc/tb" \
  --output_dir "$SCRIPT_DIR/${model_name}-tc"