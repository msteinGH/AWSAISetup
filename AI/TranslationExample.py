
import pandas as pd
data_path = "DataSets/datacamp_workspace_export_2023-12-29 17 15 58_FaceBook_Articles_very_short.csv"
news_data = pd.read_csv(data_path)
news_data.info()
news_data.head(10)

#english_texts = ["Good morning", "Can you please show me the way to the Eiffel Tower?"]

# extract column "content"
english_texts = news_data.loc[:,"content"]
from transformers import MarianTokenizer, MarianMTModel
lang = "de"
if "fr" == lang:
    model_name = 'Helsinki-NLP/opus-mt-en-fr'

if "de" == lang:
    model_name = 'Helsinki-NLP/opus-mt-en-de'

print ("Using model: ",model_name)

# Get the tokenizer
tokenizer = MarianTokenizer.from_pretrained(model_name)
# Instantiate the model
model = MarianMTModel.from_pretrained(model_name)


def format_batch_texts(language_code, batch_texts):
    formated_batch = [">>{}<< {}".format(language_code, text) for text in batch_texts]
    return formated_batch


def perform_translation(batch_texts, model, tokenizer, language):
  # Prepare the text data into appropriate format for the model
  formated_batch_texts = format_batch_texts(language, batch_texts) 
  # Generate translation using model
  translated = model.generate(**tokenizer(formated_batch_texts, return_tensors="pt", padding=True))
  # Convert the generated tokens indices back into text
  translated_texts = [tokenizer.decode(t, skip_special_tokens=True) for t in translated]
  return translated_texts


print ("starting translation")
translated_texts = perform_translation(english_texts, model, tokenizer, lang)

for text in translated_texts:
  print("Translation : \n", text)

