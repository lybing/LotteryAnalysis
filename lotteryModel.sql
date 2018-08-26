CREATE TABLE `salesinfo` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`periodId` int(11) NULL DEFAULT NULL COMMENT '期间',
	`province` char(10) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '省份',
	`salesAmount` decimal(18,2) NULL DEFAULT NULL COMMENT '销售额',
	`firstPrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '一等奖',
	`secondPrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '二等奖',
	`ThirdPrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '三等奖',
	`FourPrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '四等奖',
	`fivePrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '五等奖',
	`sixPrize` varchar(255) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '六等奖',
	PRIMARY KEY (`id`) 
)
ENGINE = InnoDB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 0
DEFAULT CHARACTER SET = gbk
COLLATE = gbk_chinese_ci
COMMENT = '记录每期的销售信息'
KEY_BLOCK_SIZE = 0
MAX_ROWS = 0
MIN_ROWS = 0
ROW_FORMAT = Compact;
CREATE TABLE `period` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`OpenDate` date NULL DEFAULT NULL COMMENT '开奖日期',
	`OpenPeriod` varchar(10) CHARACTER SET gbk COLLATE gbk_chinese_ci NULL DEFAULT NULL COMMENT '开奖期间',
	PRIMARY KEY (`id`) 
)
ENGINE = InnoDB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 0
DEFAULT CHARACTER SET = gbk
COLLATE = gbk_chinese_ci
COMMENT = '记录开奖期间'
KEY_BLOCK_SIZE = 0
MAX_ROWS = 0
MIN_ROWS = 0
ROW_FORMAT = Compact;
CREATE TABLE `winningnumbers` (
	`id` int(255) NOT NULL,
	`periodId` int(11) NULL DEFAULT NULL COMMENT '开奖期号Id',
	`OpenNumber1` int(11) NULL DEFAULT NULL COMMENT '开奖数字1',
	`OpenNumber2` int(11) NULL DEFAULT NULL COMMENT '开奖数字2',
	`OpenNumber3` int(11) NULL DEFAULT NULL COMMENT '开奖数字3',
	`OpenNumber4` int(11) NULL DEFAULT NULL COMMENT '开奖数字4',
	`OpenNumber5` int(11) NULL DEFAULT NULL COMMENT '开奖数字5',
	`OpenNumber6` int(11) NULL DEFAULT NULL COMMENT '开奖数字6',
	`OpenNumber7` int(11) NULL DEFAULT NULL COMMENT '开奖数字7',
	PRIMARY KEY (`id`) 
)
ENGINE = InnoDB
AUTO_INCREMENT = 0
AVG_ROW_LENGTH = 0
DEFAULT CHARACTER SET = gbk
COLLATE = gbk_chinese_ci
COMMENT = '记录每期的开奖数据'
KEY_BLOCK_SIZE = 0
MAX_ROWS = 0
MIN_ROWS = 0
ROW_FORMAT = Compact;

ALTER TABLE `winningnumbers` ADD CONSTRAINT `fk_winningnumbers_period` FOREIGN KEY (`periodId`) REFERENCES `period` (`id`);
ALTER TABLE `salesinfo` ADD CONSTRAINT `fk_salesinfo_period` FOREIGN KEY (`periodId`) REFERENCES `period` (`id`);

