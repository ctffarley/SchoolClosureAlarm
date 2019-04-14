import requests
from bs4 import BeautifulSoup
import re

ALERT = 'https://alert.umd.edu/alerts'

def next_close():
    # actual function commented out in order to return fake data for
    # demonstration purposes

    # page = requests.get(ALERT)

    # soup = BeautifulSoup(page.text, 'html.parser')

    # all_spans = soup.find_all('span')
    # for span in all_spans:
        # try:
            # close_string = re.search("closed", span.contents[0])
            # if close_string:
                # close = re.findall(r"\w+ \d+, \d+", close_string.string)
                # print(close)
                # return close[0].split()
        # except:
            # continue
    return ["March", 15, 2019]
