
# CLUB: Catalan Language Understanding Benchmark

## Tasks and datasets

The CLUB benchmark consists of 5 tasks, that are Part-of-Speech Tagging (POS), Named Entity Recognition (NER), 
Text Classification (TC), Semantic Textual Similarity (STS) and Question Answering (QA).
For more information, refer to the _HuggingFace datasets cards_ and _Zenodo_ links below :
 1. AnCora (POS): 
   
    - Splits info:
         - train: 13,123 examples 
         - validation: 1,709 examples
         - test: 1,846 examples

    - dataset card: https://huggingface.co/datasets/universal_dependencies

    - data source: https://github.com/UniversalDependencies/UD_Catalan-AnCora

 2. AnCora-ner (NER):
    
    - Splits info:
         - train: 10,628 examples 
         - validation: 1,427 examples
         - test: 1,526 examples
       
    - dataset card: https://huggingface.co/datasets/projecte-aina/ancora-ca-ner
    
    - data source: https://zenodo.org/record/4762031#.YKaFjqGxWUk)
   
 3. TeCla (TC):
    
    - Splits info:
         - train: 110,203  examples 
         - validation: 13,786 examples
         - test: 13,786 examples
       
    - dataset card: https://huggingface.co/datasets/projecte-aina/tecla
    
    - data source: **[TeCla](https://doi.org/10.5281/zenodo.4627197)**: consisting of 137k news pieces from the Catalan News Agency ([ACN](https://www.acn.cat/)) corpus

 4. STS-ca (STS):
    
    - Splits info:
         - train: 2,073 examples
         - validation: 500 examples
         - test: 500 examples
       
    - dataset card: https://huggingface.co/datasets/projecte-aina/sts-ca
    
    - data source: https://doi.org/10.5281/zenodo.4529183
   
 5. ViquiQuAD (QA):
    
    - Splits info:
         - train: 11,255 examples 
         - validation: 1,492 examples
         - test: 1,429 examples
       
    - dataset card: https://huggingface.co/datasets/projecte-aina
      
    - data source: https://doi.org/10.5281/zenodo.4562344
   
 6. XQuAD (QA):
   
    - Splits info:
         - test: 1,190 examples
   
   - dataset card: https://huggingface.co/datasets/projecte-aina/xquad-ca
     
   - data source: https://doi.org/10.5281/zenodo.4526223

7. TECA (Textual Entailment)

    - Splits info:
         - train: 16,930 examples
         - validation: 2116
         - test: 2117
   
   - dataset card: https://huggingface.co/datasets/projecte-aina/teca
     
   - data source: https://zenodo.org/record10.5281/zenodo.4593271.
    
## BERTa

BERTa is a transformer-based masked language model for the Catalan language, based on the [RoBERTA](https://github.com/pytorch/fairseq/tree/master/examples/roberta) base model 

Pretrained model: https://huggingface.co/PlanTL-GOB-ES/roberta-base-ca-cased
Training corpora: https://doi.org/10.5281/zenodo.4519348

## Fine-tune and evaluate on CLUB

To fine-tune and evaluate your model on the CLUB benchamark, run the following commands:

```
bash setup_venv.sh
bash run_club.sh <model_name_on_HF>
```
The commands above will run fine-tuning and evaluation on CLUB and the results will be shown in the _results-model_name_on_HF.json_ file.
and the logs in the _run_club-model_name_on_HF.log_ file.


## Fine-tuning and evaluation

For each model we used the same fine-tuning setting across tasks, consisting of 10 training epochs, with an effective
batch size of 32 instances, a max input length of 512 tokens (128 tokens in the case of Textual Entailment though) and a learning rate of 5e−5. The rest of the hyperparameters are set to the default values in Huggingface Transformers scripts. We then select the best checkpoint as the one that maximised the task-specific metric on the
corresponding validation set, and finally evaluate it on the test set.


## Results

Evaluations results obtained running the scripts above with the `<model_name_on_HF>` set to _PlanTL-GOB-ES/roberta-base-ca_:


| Model        | NER (F1)      | POS (F1)   | STS (Pearson)   | TC (accuracy) | QA (ViquiQuAD) (F1/EM)  | QA (XQuAD) (F1/EM) | TE (TECA) (accuracy) | 
| ------------|:-------------:| -----:|:------|:-------|:------|:----|:----|
| BERTa       | **89.63** | **98.93** | **81.20** | **74.04** | **86.99/73.25** | **67.81/49.43** | **79.12** |
| mBERT       | 86.38 | 98.82 | 76.34 | 70.56 | 86.97/72.22 | 67.15/46.51 | 74.78 |
| XLM-RoBERTa | 87.66 | 98.89 | 75.40 | 71.68 | 85.50/70.47 | 67.10/46.42 | 75.44 |
| WikiBERT-ca | 77.66 | 97.60 | 77.18 | 73.22 | 85.45/70.75 | 65.21/36.60 | x |

## How to cite
If you use any of these resources (datasets or models) in your work, please cite our latest paper:
```bibtex
@inproceedings{armengol-estape-etal-2021-multilingual,
    title = "Are Multilingual Models the Best Choice for Moderately Under-resourced Languages? {A} Comprehensive Assessment for {C}atalan",
    author = "Armengol-Estap{\'e}, Jordi  and
      Carrino, Casimiro Pio  and
      Rodriguez-Penagos, Carlos  and
      de Gibert Bonet, Ona  and
      Armentano-Oller, Carme  and
      Gonzalez-Agirre, Aitor  and
      Melero, Maite  and
      Villegas, Marta",
    booktitle = "Findings of the Association for Computational Linguistics: ACL-IJCNLP 2021",
    month = aug,
    year = "2021",
    address = "Online",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2021.findings-acl.437",
    doi = "10.18653/v1/2021.findings-acl.437",
    pages = "4933--4946",
}
```



