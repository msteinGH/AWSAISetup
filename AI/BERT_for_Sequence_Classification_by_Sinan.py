from transformers import Trainer, TrainingArguments, AutoModelForSequenceClassification, AutoTokenizer, \
     DataCollatorWithPadding, pipeline
from datasets import Dataset
import numpy as np
import torch
import evaluate

snips_file = open('./data/snips.train.txt', 'rb')

snips_rows = snips_file.readlines()

utterances = []
tokenized_utterances = []
sequence_labels = []

utterance, tokenized_utterance, label_for_utterances = '', [], []
for snip_row in snips_rows:
    if len(snip_row) == 2:  # skip over rows with no data
        continue
    if ' ' not in snip_row.decode():  # we've hit a sequence label
        sequence_labels.append(snip_row.decode().strip())
        utterances.append(utterance.strip())
        tokenized_utterances.append(tokenized_utterance)
        utterance = ''
        tokenized_utterance = []
        label_for_utterances = []
        continue
    token, token_label = snip_row.decode().split(' ')
    utterance += f'{token} '
    tokenized_utterance.append(token)

MODEL = 'bert-base-uncased'

tokenizer = AutoTokenizer.from_pretrained(MODEL)
unique_sequence_labels = list(set(sequence_labels))
unique_sequence_labels
sequence_labels = [unique_sequence_labels.index(l) for l in sequence_labels]

print(f'There are {len(unique_sequence_labels)} unique sequence labels')

print(tokenized_utterances[0])
print(utterances[0])
print(sequence_labels[0])
print(unique_sequence_labels[sequence_labels[0]])

snips_dataset = Dataset.from_dict(
dict(
     utterance=utterances, 
     label=sequence_labels,
    )
)

snips_dataset = snips_dataset.train_test_split(test_size=0.2)
snips_dataset
snips_dataset['train'][0]
# simple function to batch tokenize utterances with truncation
def preprocess_function(examples):
    return tokenizer(examples["utterance"], truncation=True)

seq_clf_tokenized_snips = snips_dataset.map(preprocess_function, batched=True)

# only input_ids, attention_mask, and label are used. The rest are for show
seq_clf_tokenized_snips['train'][0]

# DataCollatorWithPadding creates batch of data. It also dynamically pads text to the 
#  length of the longest element in the batch, making them all the same length. 
#  It's possible to pad your text in the tokenizer function with padding=True, dynamic padding is more efficient.

data_collator = DataCollatorWithPadding(tokenizer=tokenizer)
# Data Collator will pad data so that all examples are the same input length.
#  Attention mask is how we ignore attention scores for padding tokens
label_dict = {i: l for i, l in enumerate(unique_sequence_labels)}
label_dict

sequence_clf_model = AutoModelForSequenceClassification.from_pretrained(
    MODEL,
    num_labels=len(unique_sequence_labels),
)

# set an index -> label dictionary
sequence_clf_model.config.id2label = label_dict

sequence_clf_model.config.id2label[0]

metric = evaluate.load("accuracy")

def compute_metrics(eval_pred):  # custom method to take in logits and calculate accuracy of the eval set
    logits, labels = eval_pred
    predictions = np.argmax(logits, axis=-1)
    return metric.compute(predictions=predictions, references=labels)


epochs = 2

training_args = TrainingArguments(
    output_dir="./snips_clf/results",
    num_train_epochs=epochs,
    per_device_train_batch_size=32,
    per_device_eval_batch_size=32,
    load_best_model_at_end=True,
    logging_steps=10,
    log_level='info',
    evaluation_strategy='epoch',
    eval_steps=50,
    save_strategy='epoch',
    use_mps_device=True if torch.backends.mps.is_available() else False
)

# Define the trainer:

trainer = Trainer(
    model=sequence_clf_model,
    args=training_args,
    train_dataset=seq_clf_tokenized_snips['train'],
    eval_dataset=seq_clf_tokenized_snips['test'],
    compute_metrics=compute_metrics,  # optional
    data_collator=data_collator
)

gpt2_tokenizer = AutoTokenizer.from_pretrained('gpt2')

# Get initial metrics
trainer.evaluate()

trainer.train()

trainer.evaluate()  # sanity check, should be the same as the epoch with the lowest validation loss

trainer.save_model()