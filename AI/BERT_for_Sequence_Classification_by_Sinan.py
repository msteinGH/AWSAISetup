from transformers import Trainer, TrainingArguments, AutoModelForSequenceClassification, AutoTokenizer, \
     DataCollatorWithPadding, pipeline
from datasets import Dataset
import numpy as np
import torch
import evaluate

snips_file = open('../data/snips.train.txt', 'rb')

snips_rows = snips_file.readlines()

snips_rows[:20]