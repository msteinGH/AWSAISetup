from transformers import AutoModelForQuestionAnswering, AutoTokenizer, pipeline
import pandas as pd

model_name = "deepset/roberta-base-squad2"
task = 'question-answering'
QA_model = pipeline(task, model=model_name, tokenizer=model_name)

data_path = "Datasets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv"
news_data = pd.read_csv(data_path)

# extract column "content"
english_texts = news_data.loc[:,"content"]


#print ("Sample text: ", english_texts[1])

text_file = open(r"./PDFData/ConvertedPdf_MultiCloud.txt", 'r')
#text_file = open(r"./PDFData/ConvertedPdf_OracleCloud.txt", 'r')

context = text_file.read()
#context = english_texts[1]
question = 'which company created OCI?'
QA_input = {
          'question': question,
          'context': context
          }


model_response = QA_model(QA_input)
print ("Question:", question)
print ("Response: ",pd.DataFrame([model_response]))