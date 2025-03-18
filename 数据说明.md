# Customer_positioning_analysis
数据集来源于UCI,为2009-2016年某商业银行部分客户数据,
主要包括用户基本信息,资产状况,历史交易信息,是否购买了该理财产品等信息,根据现有信息,基于SAS Base分析,提取有价值信息供市场决策以及预测哪些新用户会购买该理财产品.


现对变量进行说明
CUST_ID     客户ID
GENDER      性别
MARR        婚姻状况
EDUCATION   教育程度
AGE         年龄
CHILDREN    子女数量
F_VIP       是否是VIP客户
F_STAFF     是否是员工
F_PAYROLL   是否有工资代发
F_YLJ       是否有养老金
F_CC        是否有信用卡
F_WEB       是否使用网银
F_MOBILE    是否使用手机银行
F_TEL       是否使用电话银行
F_FUND      是否有基金
DOB         出生日期
AUM_3       3个月的资产管理规模
FUND_3      3个月的基金投资额
DEBIT_3     3个月的借记卡消费额
AUM_6       6个月的资产管理规模
FUND_6      6个月的基金投资额
DEBIT_6     6个月的借记卡消费额
DEPOSIT_3   3个月的存款额
DEPOSIT_6   6个月的存款额
FIX_3       3个月的定期存款额
FIX_6       6个月的定期存款额
FINACE_3    3个月的理财产品投资额
FINACE_6    6个月的理财产品投资额
YJL_3       3个月的银行业务收入
YJL_6       6个月的银行业务收入
PAYROLL_3   3个月的工资代发额
PAYROLL_6   6个月的工资代发额
C_1W_D_3    3个月内的每周借记卡消费天数
C_1W_D_6    6个月内的每周借记卡消费天数
C_1W_TR_3   3个月内的每周借记卡交易次数
C_1W_TR_6   6个月内的每周借记卡交易次数
C_FIX_3     3个月内的定期存款次数
C_FIX_6     6个月内的定期存款次数
C_FUND_3    3个月内的基金交易次数
C_FUND_6    6个月内的基金交易次数
C_YJL_3     3个月内的银行业务收入次数
C_YJL_6     6个月内的银行业务收入次数
C_DEBIT_3   3个月内的借记卡交易次数
C_DEBIT_6   6个月内的借记卡交易次数
C_FIANCE_3  3个月内的理财产品投资次数
C_FIANCE_6  6个月内的理财产品投资次数
GAP_FINACE_3    3个月内理财产品投资额与平均投资额的差值
GAP_FIANCE_6    6个月内理财产品投资额与平均投资额的差值
DT_L_FINACE     理财产品最后一次投资距今的天数
CHANNEL_PRE     上次交易渠道
A_L_FIANCE      累计理财产品投资额
TARGET          是否购买理财产品 1购，0未购买
