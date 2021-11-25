#!/usr/bin/env bash
# Script to fine-tune the pretrained BERTa model and evaluate it on the CLUB tasks
# Make sure 4 GPUs are available to reach the batch size of 32
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Start fine-tuning and evaluation on CLUB tasks"
# Part-of-Speech Tagging
echo "Task: Part-of-Speech Tagging"
bash $SCRIPT_DIR/src/pos/run_pos.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo "POS";
  echo -n "F1 = ";
  grep  -Po "(?<=predict_f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/pos/roberta-base-ca-cased-pos/predict_results.json ; } \
  | tee  $SCRIPT_DIR/results.txt


# Named Entity Recognition
echo "Task: Named Entity Recognition"
bash $SCRIPT_DIR/src/ner/run_ner.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo -e "\nNER";
  echo -n "F1 = ";
  grep  -Po "(?<=predict_f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/ner/roberta-base-ca-cased-ner/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt


# Semantic Textual Similarity
echo "Task: Semantic Textual Similarity"
bash $SCRIPT_DIR/src/sts/run_sts.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo -e "\nSTS";
  echo -n "Pearson_Spearmanr = ";
  grep  -Po "(?<=predict_combined_score\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/sts/roberta-base-ca-cased-sts/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt


# Text Classification
echo "Task: Text Classification"
bash $SCRIPT_DIR/src/tc/run_tc.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo -e "\nTC";
  echo -n "Accuracy = ";
  grep  -Po "(?<=predict_accuracy\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/tc/roberta-base-ca-cased-tc/eval_testset/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt


# Textual Entailment
echo "Task: Textual Entailment"
bash $SCRIPT_DIR/src/te/run_te.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo -e "\nTE";
  echo -n "Accuracy = ";
  grep  -Po "(?<=predict_accuracy\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/tc/roberta-base-ca-cased-te/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt


# Question-answering
echo "Task: Question-answering"
bash $SCRIPT_DIR/src/qa/run_qa.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log

## Get results
{ echo -e "\nQA";
  echo -e "ViquiQuAD";
  echo -n "F1 = ";
  grep  -Po "(?<=f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/qa/roberta-base-ca-cased-qa/viquiquad/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt

{ echo -e "\nQA";
  echo -e "xquad-ca";
  echo -n "F1 = ";
  grep  -Po "(?<=f1\": )[0-9]\.[0-9]+" $SCRIPT_DIR/src/qa/roberta-base-ca-cased-qa/xquad-ca/predict_results.json ; } \
  | tee -a $SCRIPT_DIR/results.txt

# TODO: add python script to collect the results in a json or table.
echo "Done"