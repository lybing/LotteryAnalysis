import requests
from bs4 import BeautifulSoup
import re
from lotterymodel import PeriodModel,WinningNumberModel,SalesInfoModel

def getTableRows(pageIndex):
    url = 'http://kaijiang.zhcw.com/zhcw/html/ssq/list_%s.html'%pageIndex
    data_page = requests.get(url).content
    data_html = BeautifulSoup(data_page, "html.parser")
    return data_html.table.find_all('tr')

def parsePage():    
    bs_tr_array = getTableRows(1)

    # page count
    pageCount = int(bs_tr_array[-1].td()[2].text)

    parseItem(bs_tr_array[2:-1])

    for currentIndex in range(1, pageCount):
        parseItem(getTableRows(currentIndex)[2:-1])
        
def parseItem(tr_array):
    for tr_item in tr_array:
        # Period
        period = PeriodModel()
        period.openDate = tr_item.find_all('td')[0].text
        period.openPeriod = tr_item.find_all('td')[1].text
        print (period.openDate, period.openPeriod)

        winningNumber = WinningNumberModel()
        reg_numbers = re.finditer(r'\d+', tr_item.find_all('td')[2].text)
        numIndex = 0
        for matched_num in reg_numbers:
            numIndex += 1
            winningNumber.__setattr__("OpenNumber%s"%numIndex, matched_num.group())
            print ("OpenNumber%s"%numIndex, matched_num.group())
        
    return None

# 解析开奖信息Html
parsePage()