CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_HitTimes`()
BEGIN
	#Routine body goes here...
	CREATE TEMPORARY TABLE temp_number_list 
	select 1 OpenNumber union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9 
	union select 10 union select 11 union select 12 union select 13 union select 14 union select 15 union select 16 union select 17 union select 18 
	union select 19 union select 20 union select 21 union select 22 union select 23 union select 24 union select 25 union select 26 
	union select 27 union select 28 union select 29 union select 30 union select 31 union select 32 union select 33; 
	CREATE TEMPORARY TABLE temp_number1 SELECT OpenNumber1 OpenNumber, count(OpenNumber1) as numCount from winningnumbers group by OpenNumber1; 
	CREATE TEMPORARY TABLE temp_number2 SELECT OpenNumber2 OpenNumber, count(OpenNumber2) as numCount from winningnumbers group by OpenNumber2; 
	CREATE TEMPORARY TABLE temp_number3 SELECT OpenNumber3 OpenNumber, count(OpenNumber3) as numCount from winningnumbers group by OpenNumber3; 
	CREATE TEMPORARY TABLE temp_number4 SELECT OpenNumber4 OpenNumber, count(OpenNumber4) as numCount from winningnumbers group by OpenNumber4; 
	CREATE TEMPORARY TABLE temp_number5 SELECT OpenNumber5 OpenNumber, count(OpenNumber5) as numCount from winningnumbers group by OpenNumber5; 
	CREATE TEMPORARY TABLE temp_number6 SELECT OpenNumber6 OpenNumber, count(OpenNumber6) as numCount from winningnumbers group by OpenNumber6; 
	CREATE TEMPORARY TABLE temp_number7 SELECT OpenNumber7 OpenNumber, count(OpenNumber7) as numCount from winningnumbers group by OpenNumber7; 
	SELECT nList.OpenNumber, 
			(IFNULL(n1.numCount,0)+IFNULL(n2.numCount,0)+IFNULL(n3.numCount,0) 
					+IFNULL(n4.numCount,0)+IFNULL(n5.numCount,0)+IFNULL(n6.numCount,0) 
					+IFNULL(n7.numCount,0) 
					) OpenNumberCount 
	from temp_number_list nList 
	left join temp_number1 n1 on n1.OpenNumber=nList.OpenNumber 
	left join temp_number2 n2 on n2.OpenNumber=nList.OpenNumber 
	left join temp_number3 n3 on n3.OpenNumber=nList.OpenNumber 
	left join temp_number4 n4 on n4.OpenNumber=nList.OpenNumber 
	left join temp_number5 n5 on n5.OpenNumber=nList.OpenNumber 
	left join temp_number6 n6 on n6.OpenNumber=nList.OpenNumber 
	left join temp_number7 n7 on n7.OpenNumber=nList.OpenNumber; 
	DROP TEMPORARY TABLE IF EXISTS temp_number_list; 
	DROP TEMPORARY TABLE IF EXISTS temp_number1; 
	DROP TEMPORARY TABLE IF EXISTS temp_number2; 
	DROP TEMPORARY TABLE IF EXISTS temp_number3; 
	DROP TEMPORARY TABLE IF EXISTS temp_number4; 
	DROP TEMPORARY TABLE IF EXISTS temp_number5; 
	DROP TEMPORARY TABLE IF EXISTS temp_number6; 
	DROP TEMPORARY TABLE IF EXISTS temp_number7;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_FrequencyOnEachPosition_v2`()
BEGIN
	#Routine body goes here...
	CREATE TEMPORARY TABLE temp_number_list 
	select 1 num union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9 
	union select 10 union select 11 union select 12 union select 13 union select 14 union select 15 union select 16 union select 17 union select 18 
	union select 19 union select 20 union select 21 union select 22 union select 23 union select 24 union select 25 union select 26 
	union select 27 union select 28 union select 29 union select 30 union select 31 union select 32 union select 33; 
	
  CREATE TEMPORARY TABLE temp_number1 SELECT RedNumber1 RedNumber, count(RedNumber1) as numCount from winningnumbers_v2 group by RedNumber1; 
	CREATE TEMPORARY TABLE temp_number2 SELECT RedNumber2 RedNumber, count(RedNumber2) as numCount from winningnumbers_v2 group by RedNumber2; 
	CREATE TEMPORARY TABLE temp_number3 SELECT RedNumber3 RedNumber, count(RedNumber3) as numCount from winningnumbers_v2 group by RedNumber3; 
	CREATE TEMPORARY TABLE temp_number4 SELECT RedNumber4 RedNumber, count(RedNumber4) as numCount from winningnumbers_v2 group by RedNumber4; 
	CREATE TEMPORARY TABLE temp_number5 SELECT RedNumber5 RedNumber, count(RedNumber5) as numCount from winningnumbers_v2 group by RedNumber5; 
	CREATE TEMPORARY TABLE temp_number6 SELECT RedNumber6 RedNumber, count(RedNumber6) as numCount from winningnumbers_v2 group by RedNumber6; 
	CREATE TEMPORARY TABLE temp_blueNumber SELECT BlueNumber, count(BlueNumber) as numCount from winningnumbers_v2 group by BlueNumber; 
	
	SELECT nList.num,
				IFNULL(n1.numCount,0) num1Count, IFNULL(n2.numCount,0) num2Count
				,IFNULL(n3.numCount,0) num3Count, IFNULL(n4.numCount,0) num4Count
				,IFNULL(n5.numCount,0) num5Count, IFNULL(n6.numCount,0) num6Count
				,IFNULL(n7.numCount,0) num7Count 
	from temp_number_list nList 
	left join temp_number1 n1 on n1.RedNumber=nList.num 
	left join temp_number2 n2 on n2.RedNumber=nList.num 
	left join temp_number3 n3 on n3.RedNumber=nList.num 
	left join temp_number4 n4 on n4.RedNumber=nList.num 
	left join temp_number5 n5 on n5.RedNumber=nList.num 
	left join temp_number6 n6 on n6.RedNumber=nList.num 
	left join temp_blueNumber n7 on n7.BlueNumber=nList.num; 
	
	DROP TEMPORARY TABLE IF EXISTS temp_number1; 
	DROP TEMPORARY TABLE IF EXISTS temp_number2; 
	DROP TEMPORARY TABLE IF EXISTS temp_number3; 
	DROP TEMPORARY TABLE IF EXISTS temp_number4; 
	DROP TEMPORARY TABLE IF EXISTS temp_number5; 
	DROP TEMPORARY TABLE IF EXISTS temp_number6; 
	DROP TEMPORARY TABLE IF EXISTS temp_blueNumber;

	DROP TEMPORARY TABLE IF EXISTS temp_number_list; 
END