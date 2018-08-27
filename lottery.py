import requests
from bs4 import BeautifulSoup
import re
import pymysql
from pyecharts import Bar
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

        winningNumber = WinningNumberModel()
        reg_numbers = re.finditer(r'\d+', tr_item.find_all('td')[2].text)
        numIndex = 0
        for matched_num in reg_numbers:
            numIndex += 1
            winningNumber.__setattr__("OpenNumber%s"%numIndex, matched_num.group())
        
        storeLotteryInfo(period, winningNumber)
    
    return None

def storeLotteryInfo(period, winningNumber):
    try:
        conn = getConnection()
        with conn.cursor() as cursor:
            # Create a new record
            sqlPeriod = "INSERT INTO `period` (`OpenDate`, `OpenPeriod`) VALUES (%s, %s)"
            cursor.execute(sqlPeriod, (period.openDate, period.openPeriod))
            
            sqlWinningNumber = "INSERT INTO `winningnumbers` (`periodId`, `OpenNumber1`, `OpenNumber2`, `OpenNumber3`, `OpenNumber4`, `OpenNumber5`, `OpenNumber6`, `OpenNumber7`) SELECT LAST_INSERT_ID(), %s, %s, %s, %s, %s, %s, %s"
            cursor.execute(sqlWinningNumber, (winningNumber.OpenNumber1, winningNumber.OpenNumber2, winningNumber.OpenNumber3, winningNumber.OpenNumber4, winningNumber.OpenNumber5, winningNumber.OpenNumber6, winningNumber.OpenNumber7))
        # connection is not autocommit by default. So you must commit to save
        # your changes.
        conn.commit()
    except Exception as storeError:
        print(storeError)
    finally:
        conn.close()

def getConnection():
    return pymysql.connect(host='localhost',
                             user='root',
                             password='1a2B3///',
                             db='lottery',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

def analysisHitTimes():
    # 使用cursor()方法获取操作游标 
    conn  = getConnection()
    cursor = conn.cursor()
    
    try:
        # 执行SQL语句
        cursor.execute('CALL Proc_HitTimes()')
        # 获取所有记录列表
        results = cursor.fetchall()
        
        bar = Bar("双色球分析", "每个数字的命中次数")
        bar.use_theme('dark')
        
        textList = []
        valueList = []
        for row in results:
            textList.append(row['OpenNumber'])
            valueList.append(row['OpenNumberCount'])

        bar.add("命中次数", textList, valueList)

        bar.render()
    except Exception as queryError:
        print(queryError)
    finally:
        conn.close()

# 解析开奖信息Html
parsePage()

# 展示分析结果
analysisHitTimes()