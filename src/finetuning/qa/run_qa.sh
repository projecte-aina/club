#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Train and test on ViquiQuAD
python $SCRIPT_DIR/run_qa.py \
  --model_name_or_path "bsc/roberta-base-ca-cased" \
  --dataset_name "bsc/viquiquad" \
  --do_train \
  --do_eval \
  --do_predict \
  --per_device_train_batch_size 4 \
  --gradient_accumulation_steps 2 \
  --num_train_epochs 10 \
  --max_seq_length 512 \
  --load_best_model_at_end \
  --metric_for_best_model f1 \
  --evaluation_strategy epoch \
  --seed 1 \
  --logging_dir "$SCRIPT_DIR/roberta-base-ca-cased-qa/viquiquad/tb" \
  --output_dir "$SCRIPT_DIR/roberta-base-ca-cased-qa/viquiquad"

# Test the previous fine-tuned model on XQuAD
python $SCRIPT_DIR/run_qa.py \
  --model_name_or_path "$SCRIPT_DIR/roberta-base-ca-cased-qa/viquiquad" \
  --dataset_name "bsc/xquad-ca" \
  --do_predict \
  --per_device_train_batch_size 8 \
  --max_seq_length 512 \
  --seed 1 \
  --output_dir "$SCRIPT_DIR/roberta-base-ca-cased-qa/xquad-ca"

# Evaluate with the script "mlqa_evaluation_ca.py" script
python $SCRIPT_DIR/mlqa_evaluation_ca.py \
  --testset $SCRIPT_DIR/viquiquad-test.json \
  --prediction_file "$SCRIPT_DIR/roberta-base-ca-cased-qa/viquiquad/predict_predictions.json" \
  --answer_language "ca" \
  > "$SCRIPT_DIR/roberta-base-ca-cased-qa/viquiquad/predict_results.json"

python $SCRIPT_DIR/mlqa_evaluation_ca.py \
  --testset $SCRIPT_DIR/xquad-ca.json \
  --prediction_file "$SCRIPT_DIR/roberta-base-ca-cased-qa/xquad-ca/predict_predictions.json" \
  --answer_language "ca" \
  > "$SCRIPT_DIR/roberta-base-ca-cased-qa/xquad-ca/predict_results.json"