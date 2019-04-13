import requests
from bs4 import BeautifulSoup
import re

ALERT = 'https://alert.umd.edu/alerts'

page = requests.get(ALERT)

soup = BeautifulSoup(page.text, 'html.parser')

thing = soup.find(class_ = "field-item")
all_spans = soup.find_all('span')
for span in all_spans:
    try:
        close_string = re.search("closed", span.contents[0])
        if close_string:
            print(re.findall(r"\w+, \w+ \d+, \d+", close_string.string))
    except:
        continue
