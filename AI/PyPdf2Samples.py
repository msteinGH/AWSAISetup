# get_doc_info.py

path = 'reportlab-sample.pdf'


from PyPDF2 import PdfReader
def get_info(path):
    with open(path, 'rb') as f:
        pdf = PdfReader(f)
        info = pdf.metadata
        number_of_pages = len(pdf.pages)
        print ("Printing Info:")
        print(info)
        author = info.author
        creator = info.creator
        producer = info.producer
        subject = info.subject
        title = info.title
    print ("######################################################################")
#path = 'PDFData/Oracle Cloud Infrastructure.pdf'
path = 'PDFData/Multi-Cloud Strategy.pdf'

# extracting_text.py
def text_extractor(path):
    with open(path, 'rb') as f:
        pdf = PdfReader(f)
        # get the first page
        page = pdf.pages[35]
        print ("Printing Page:") 
        print(page)
        print ("######################################################################")
        print('Page type: {}'.format(str(type(page))))
        print ("######################################################################")
        text = page.extract_text()
        print(text)
        print ("######################################################################")


def pdf_to_text(path):
    out_file = open(r"./ConvertedPdf_OracleCloud.txt",'w')
    with open(path, 'rb') as f:
        pdf = PdfReader(f)    
        for page in pdf.pages:
            out_file.writelines(page.extract_text())
            #print(page.extract_text())
            #print ("######################################################################")
    out_file.close()

#text_extractor(path)

#get_info(path)

pdf_to_text(path)




