from transformers import AutoModelForSequenceClassification, AutoTokenizer, MarianTokenizer, MarianMTModel


# BERT classification
tokenizer = AutoTokenizer.from_pretrained('bert-base-uncased')
sequence_clf_model = AutoModelForSequenceClassification.from_pretrained(
    'bert-base-uncased',
    7,
)

#translation models 
tokenizer_DE = MarianTokenizer.from_pretrained('Helsinki-NLP/opus-mt-en-de')
model_DE = MarianMTModel.from_pretrained('Helsinki-NLP/opus-mt-en-de')
tokenizer_FR = MarianTokenizer.from_pretrained('Helsinki-NLP/opus-mt-en-fr')
model_FR = MarianMTModel.from_pretrained('Helsinki-NLP/opus-mt-en-fr')
