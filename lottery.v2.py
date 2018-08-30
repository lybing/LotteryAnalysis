import requests
import re
import pymysql
from pyecharts import Bar, Pie, Bar3D
from lotterymodel import PeriodModel,WinningNumberModel,SalesInfoModel

def getContent():
    url = 'https://datachart.500.com/ssq/history/newinc/outball.php?start=01001&end=18100'
    return requests.get(url).text

def parsePage():
    try:
        htmlContent = getContent()
        # htmlContent = htmlContent[htmlContent.index('tbody'):]

        # 这里要注意Python中正则表达式的分组要加P，如(?P<groupName>5555)
        reg_rows = re.finditer('\<td[^>]*?>(\d{5})\<\/td\>\<td[^>]*?>(\d{4}-\d{2}-\d{2})\<\/td\><td[^>]+>(?P<num1>\d{2})\<\/td\>\<td[^>]+>(?P<num2>\d{2})\<\/td\>\<td[^>]+>(?P<num3>\d{2})\<\/td\>\<td[^>]+>(?P<num4>\d{2})\<\/td\>\<td[^>]+>(?P<num5>\d{2})\<\/td\>\<td[^>]+>(?P<num6>\d{2})\<\/td\>.*?font4\"\>(?P<blue>\d+)', htmlContent)
        for tr_item in reg_rows:
            period = PeriodModel()
            period.openDate = tr_item.group(2)
            period.openPeriod = tr_item.group(1)

            winningNumber = WinningNumberModel()
            winningNumber.RedNumber1 = tr_item.group('num1')
            winningNumber.RedNumber2 = tr_item.group('num2')
            winningNumber.RedNumber3 = tr_item.group('num3')
            winningNumber.RedNumber4 = tr_item.group('num4')
            winningNumber.RedNumber5 = tr_item.group('num5')
            winningNumber.RedNumber6 = tr_item.group('num6')
            winningNumber.BlueNumber = tr_item.group('blue')
            
            storeLotteryInfo(period, winningNumber)

    except Exception as err:
        print(err)
    finally:
        print('ok')
  
def storeLotteryInfo(period, winningNumber):
    try:
        conn = getConnection()
        with conn.cursor() as cursor:
            # Create a new record
            sqlPeriod = "INSERT INTO `period_v2` (`OpenDate`, `OpenPeriod`) VALUES (%s, %s)"
            cursor.execute(sqlPeriod, (period.openDate, period.openPeriod))
            
            sqlWinningNumber = "INSERT INTO `winningnumbers_v2` (`periodId`, `RedNumber1`, `RedNumber2`, `RedNumber3`, `RedNumber4`, `RedNumber5`, `RedNumber6`, `BlueNumber`) SELECT LAST_INSERT_ID(), %s, %s, %s, %s, %s, %s, %s"
            cursor.execute(sqlWinningNumber, (winningNumber.RedNumber1, winningNumber.RedNumber2, winningNumber.RedNumber3, winningNumber.RedNumber4, winningNumber.RedNumber5, winningNumber.RedNumber6, winningNumber.BlueNumber))
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

def getFrequency(data_row, colIdx):
    return (data_row['num%dCount'%colIdx]/(data_row['num1Count']+data_row['num2Count']+data_row['num3Count']+data_row['num4Count']+data_row['num5Count']+data_row['num6Count']+data_row['num7Count']))*100

def analysisFrequency_Pie3D():
    # 使用cursor()方法获取操作游标 
    conn  = getConnection()
    cursor = conn.cursor()
    
    try:
        # 执行SQL语句
        cursor.execute('CALL Proc_FrequencyOnEachPosition_v2()')
        # 获取所有记录列表
        results = cursor.fetchall()
        
        ds = []
        x_axis_list = [i for i in range(1, 34)]
        y_axis_list = [i for i in range(1, 8)]

        for num in x_axis_list:
            for num_position in y_axis_list:
                frequency = getFrequency(results[num-1],num_position)
                ds.append([num, num_position, frequency])

        bar3D = Bar3D()
        bar3D.use_theme('dark')
        #realisticMaterial={"roughness": 0.3, "metalness": 1},
        bar3D.add("每个位置上出现的频率", x_axis_list, y_axis_list, ds, environment="#000", grid3d_shading='realistic',
        postEffect={"enable": "true","SSAO":{"enable": "true","radius": 5}}, 
        light={ "main":{"intensity":3}, "ambientCubemap":{"texture": 'data-gl/asset/pisa.hdr',"exposure": 1,"diffuseIntensity": 0.5,"specularIntensity": 2} },
        itemStyle={ "color": '#ccc'}, zAxis3D={"type":'value',"max":10, "min":0 },
        barSize=4,bevelSize=0.4,bevelSmoothness=4, emphasis={"label":{"show":"false"}})
        
        bar3D.render()
    except Exception as queryError:
        print(queryError)
    finally:
        conn.close()

# 解析开奖信息Html
# parsePage()

# 以Pie的方式展示每个数字的频率
analysisFrequency_Pie3D()