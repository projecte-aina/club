#!/usr/bin/env bash
# Script to fine-tune the pretrained BERTa model and evaluate it on the CLUB tasks
# Make sure 4 GPUs are available to reach the batch size of 32
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/venv/bin/activate
model_name="$1"

echo "Start fine-tuning and evaluation on CLUB tasks"
echo "Using model: ${model_name}"

# Part-of-Speech Tagging
echo "Task: Part-of-Speech Tagging"
bash $SCRIPT_DIR/src/pos/run_pos.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo "POS";
  echo -n "F1 = ";
  grep  -Po "(?<=predict_f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/pos/${model_name}-pos/predict_results.json ; } \
  | tee  $SCRIPT_DIR/results-$(basename ${model_name})


# Named Entity Recognition
echo "Task: Named Entity Recognition"
bash $SCRIPT_DIR/src/ner/run_ner.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo -e "\nNER";
  echo -n "F1 = ";
  grep  -Po "(?<=predict_f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/ner/${model_name}-ner/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})


# Semantic Textual Similarity
echo "Task: Semantic Textual Similarity"
bash $SCRIPT_DIR/src/sts/run_sts.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo -e "\nSTS";
  echo -n "Pearson_Spearmanr = ";
  grep  -Po "(?<=predict_combined_score\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/sts/${model_name}-sts/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})


# Text Classification
echo "Task: Text Classification"
bash $SCRIPT_DIR/src/tc/run_tc.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo -e "\nTC";
  echo -n "Accuracy = ";
  grep  -Po "(?<=predict_accuracy\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/tc/${model_name}-tc/eval_testset/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})


# Textual Entailment
echo "Task: Textual Entailment"
bash $SCRIPT_DIR/src/te/run_te.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo -e "\nTE";
  echo -n "Accuracy = ";
  grep  -Po "(?<=predict_accuracy\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/tc/${model_name}-te/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})


# Question-answering
echo "Task: Question-answering"
bash $SCRIPT_DIR/src/qa/run_qa.sh ${model_name} 2>&1 | tee -a $SCRIPT_DIR/run_club-$(basename ${model_name}).log

## Get results
{ echo -e "\nQA";
  echo -e "ViquiQuAD";
  echo -n "F1 = ";
  grep  -Po "(?<=f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/qa/${model_name}-qa/viquiquad/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})

{ echo -e "\nQA";
  echo -e "xquad-ca";
  echo -n "F1 = ";
  grep  -Po "(?<=f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/qa/${model_name}-qa/xquad-ca/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results-$(basename ${model_name})

# TODO: add python script to collect the results in a json or table.
echo "Done"