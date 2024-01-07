from transformers import AutoModelForSequenceClassification, AutoTokenizer, MarianTokenizer, MarianMTModel, AutoModelForQuestionAnswering, AutoTokenizer, pipeline



# BERT classification
tokenizer = AutoTokenizer.from_pretrained('bert-base-uncased')
sequence_clf_model = AutoModelForSequenceClassification.from_pretrained(
    'bert-base-uncased',
    num_labels=7
)



tokenizer_BERT_DE = AutoTokenizer.from_pretrained('bert-base-german-cased')
sequence_clf_model_BERT_DE = AutoModelForSequenceClassification.from_pretrained(
    'bert-base-german-cased',
        num_labels=7
)
#translation models 
tokenizer_DE = MarianTokenizer.from_pretrained('Helsinki-NLP/opus-mt-en-de')
model_DE = MarianMTModel.from_pretrained('Helsinki-NLP/opus-mt-en-de')
tokenizer_FR = MarianTokenizer.from_pretrained('Helsinki-NLP/opus-mt-en-fr')
model_FR = MarianMTModel.from_pretrained('Helsinki-NLP/opus-mt-en-fr')


# Roberta Q&A
model_name = "deepset/roberta-base-squad2"
task = 'question-answering'
QA_model = pipeline(task, model=model_name, tokenizer=model_name)
