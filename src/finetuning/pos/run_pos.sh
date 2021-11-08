#!/usr/bin bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export MAX_LENGTH=512
python $SCRIPT_DIR/run_pos.py \
  --model_name_or_path "bsc/roberta-base-ca-cased" \
  --tag_name "upos" \
  --dataset_name "universal_dependencies" \
  --dataset_config_name "ca_ancora" \
  --do_train \
  --do_eval \
  --do_predict \
  --per_device_train_batch_size 4 \
  --gradient_accumulation_steps 2 \
  --num_train_epochs 10 \
  --load_best_model_at_end \
  --metric_for_best_model f1 \
  --evaluation_strategy epoch \
  --save_strategy epoch \
  --seed 1 \
  --logging_dir "$SCRIPT_DIR/test-roberta-base-ca-cased-pos/tb" \
  --output_dir "$SCRIPT_DIR/test-roberta-base-ca-cased-pos"
