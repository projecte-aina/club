#!/usr/bin/env bash
# Script to fine-tune the pretrained BERTa model and evaluate it on the CLUB tasks
# Make sure 4 GPUs are available to reach the batch size of 32
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Start fine-tuning and evaluation on CLUB tasks"
# Part-of-Speech Tagging
echo "Task: Part-of-Speech Tagging"
bash $SCRIPT_DIR/src/finetuning/pos/run_pos.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log
echo -e "End POS\n"

# Named Entity Recognition
echo "Task: Named Entity Recognition"
bash $SCRIPT_DIR/src/finetuning/ner/run_ner.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log
echo -e "End POS\n"

# Question-answering
echo "Task: Question-answering"
bash $SCRIPT_DIR/src/finetuning/qa/run_qa.sh 2>&1 | tee -a $SCRIPT_DIR/finetune_berta_club.log
echo -e "End QA\n"
