from transformers import AutoModelForQuestionAnswering, AutoTokenizer, pipeline
import pandas as pd

model_name = "deepset/roberta-base-squad2"
task = 'question-answering'
QA_model = pipeline(task, model=model_name, tokenizer=model_name)

data_path = "DataSets/datacamp_workspace_export_2023-12-29_FaceBook_Articles_very_short.csv"
news_data = pd.read_csv(data_path)

# extract column "content"
english_texts = news_data.loc[:,"content"]


print ("Sample text: ", english_texts[1])

QA_input = {
          'question': 'what did the CSO do?',
          'context': english_texts[1]
          }


model_response = QA_model(QA_input)
print ("Response: ",pd.DataFrame([model_response]))