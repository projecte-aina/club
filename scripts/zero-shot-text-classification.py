from typing import Sequence
from packaging.version import parse
from transformers import pipeline, AutoModelForTokenClassification, AutoTokenizer
import argparse

model = AutoModelForTokenClassification.from_pretrained('PlanTL-GOB-ES/roberta-base-ca-cased-te',
                                                        use_auth_token=True)
tokenizer = AutoTokenizer.from_pretrained('PlanTL-GOB-ES/roberta-base-ca-cased-te',
                                                        use_auth_token=True)
pipe = pipeline('zero-shot-classification', model=model, tokenizer=tokenizer)

parser = argparse.ArgumentParser()
parser.add_argument('--text')
parser.add_argument('--labels', nargs='+')
args = parser.parse_args()

text = 'Els pressupostos catalans assumeixen un rècord inversor gràcies als fons de la UE.' 
labels = ["política", "esport", "notícies", "societat"]
labels = ["notícies", "esport"]
# result = pipe(sequences=args.text, candidate_labels=args.labels, hypothesis_template="aquest exemple és {}.")
result = pipe(sequences=text, candidate_labels=labels, hypothesis_template="aquest exemple és {}.")
print(result)