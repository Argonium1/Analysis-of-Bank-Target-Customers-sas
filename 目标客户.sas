/*���ݴ���*/
**��������**;
proc import out=finance
      datafile="F:\Desktop\sas\1(UTF-8).csv" dbms=csv replace;
run;

**��������**; 
proc contents data=finance; 
run; 
 
/*��ֵ����*/ 
%let var=AGE AUM_3 AUM_6 A_L_FIANCE CHILDREN CUST_ID C_1W_D_3 C_1W_D_6  
		C_1W_TR_3 C_1W_TR_6 C_FIANCE_6 C_FIX_3 C_FIX_6 C_FUND_3 C_FUND_6  
		DEBIT_3 DEBIT_6 DEPOSIT_3 DEPOSIT_6 DOB DT_L_FINACE FINACE_3 FINACE_6  
		FIX_3 FIX_6 FUND_3 FUND_6 GAP_FIANCE_6 PAYROLL_3 PAYROLL_6 TARGET YJL_6; 
 
/*�ַ�����*/ 
%let char=CHANNEL_PRE C_DEBIT_3 C_DEBIT_6 C_FIANCE_3 C_YJL_3 C_YJL_6  
			EDUCATION F_CC F_CLOAN F_FUND F_HLOAN F_MOBILE F_PAYROLL F_STAFF F_TEL  
			F_VIP F_WEB F_YJL F_YLJ GAP_FINACE_3 GENDER MARR YJL_3; 
 
**ͳ����ֵ�ͱ���**; 
proc means data=finance n nmiss mean median min max; /* ������а����۲��� (n)��ȱʧֵ���� (nmiss)����ֵ (mean)����λ�� (median)����Сֵ (min)�����ֵ (max) */ 
     var &var; /* ʹ�� VAR ���ָ��Ҫ����ͳ�Ʒ����ı��� */ 
run; 
**ͳ���ַ��ͱ���**; 
proc freq data=finance; 
   table &char /* ʹ�� TABLE ���ָ��Ҫ����Ƶ�ʷ������ַ��ͱ��� */ 
	/plots(only)=freqplot; /* ʹ�� PLOTS ѡ������Ƶ��ͼ */ 
run; 

/*��������*/
data finance;
    set finance;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    C_FIANCE_3_n = input(C_FIANCE_3, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop C_FIANCE_3;
run;

data finance;
    set finance;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    GAP_FINACE_3_n = input(GAP_FINACE_3, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop GAP_FINACE_3;
run;

data finance;
set finance(rename=(C_FIANCE_3_n=C_FIANCE_3));
set finance(rename=(GAP_FINACE_3_n=GAP_FINACE_3));
run;

/*��ֵ����*/
%let var=AGE AUM_3 AUM_6 A_L_FIANCE CHILDREN CUST_ID C_1W_D_3 C_1W_D_6 
		C_1W_TR_3 C_1W_TR_6 C_FIANCE_6 C_FIX_3 C_FIX_6 C_FUND_3 C_FUND_6 
		DEBIT_3 DEBIT_6 DEPOSIT_3 DEPOSIT_6 DOB DT_L_FINACE FINACE_3 FINACE_6 
		FIX_3 FIX_6 FUND_3 FUND_6 GAP_FIANCE_6 PAYROLL_3 PAYROLL_6 TARGET YJL_6 C_FIANCE_3 GAP_FINACE_3;

/*�ַ�����*/
%let char=CHANNEL_PRE C_DEBIT_3 C_DEBIT_6 C_YJL_3 C_YJL_6 
			EDUCATION F_CC F_CLOAN F_FUND F_HLOAN F_MOBILE F_PAYROLL F_STAFF F_TEL 
			F_VIP F_WEB F_YJL F_YLJ GENDER MARR YJL_3;


/*��������*/
/*ȥ��*/
proc SQL;
    create table fin_dis as
    select distinct * from finance order by CUST_ID;
quit;
/*������ϴ*/

proc sql;
delete from finance  where CUST_ID not in (select min(CUST_ID) from finance group by _numerie_, _character_ );
run;

**���������target 0 1 ռ���ж������Ƿ����**;
proc freq data=fin_dis;
   table target
	/missing;
run;

/*0/1 ռ��34:1 ���ݲ�����,ƽ�����ݼ�*/
data fin_1 fin_0;
   set fin_dis;
   if target=1 then output fin_1;
      else output fin_0;
run;
/*����fin_1���������� ����ʹ1 0ռ�� 1:3 */
**�������**;
proc surveyselect data=fin_0 
        out=fin_slt_0 method=srs seed=12345  n=22228;
run;

/*�ϳɾ������ݼ�*/
data fin_bal;
	set fin_slt_0 fin_1;
run;

/*�鿴����ȱʧ���������ȱʧ�������п����������ݲ����⵼��, Ҫ�ȳ�ȡ�������ݼ�*/
proc means data=fin_bal N Nmiss min max;
   var &var;
run;

proc freq data=fin_bal;
   table &char
	/missing;
run;

*ɸ��ȱʧռ�ȴ�85%���ϵı���;
%let miss=C_DEBIT_3 C_DEBIT_6 C_FUND_3 C_YJL_3 C_FUND_6 YJL_3 PAYROLL_3 
C_1W_D_3 C_YJL_6 C_FIX_3 YJL_6 PAYROLL_6 EDUCATION C_1W_D_6 C_FIX_6 MARR;
			
/*���ͻ�ID, �����TARGET��, ��Ҫɸѡ�ı������У� 39-2=37  */
/*��ֵ�ͱ�����21 */
%let var1=C_1W_TR_3  FIX_3  FIX_6  FINACE_3  C_FIANCE_6  GAP_FIANCE_6  FINACE_6 
			C_1W_TR_6  A_L_FIANCE  DT_L_FINACE  DEPOSIT_3  DEPOSIT_6  AGE  AUM_3 
			DEBIT_3  DEBIT_6  FUND_3  AUM_6  FUND_6  CHILDREN  DOB ;

/*�ַ��ͱ���: 16 */
%let char1=F_CC  F_CLOAN  F_FUND  F_HLOAN  F_MOBILE  F_PAYROLL  F_STAFF  F_TEL  F_VIP 
			F_WEB  F_YJL  F_YLJ  CHANNEL_PRE  C_FIANCE_3  GAP_FINACE_3  GENDER;

/*ʹ������,ѭ��, ���ַ��ͱ����ر���*/
%macro recod(in_data,out_data);
data &out_data(drop=i);
 	set &in_data;
	array cha{*}_character_;
	do i=1 to dim(cha);
	   if cha{i}='YES' then cha{i}=1;
	      else if cha{i}='NO' then cha{i}=0;
		  else if cha{i}='����' then cha{i}=1;
		  else if cha{i}='Ů��' then cha{i}=0;
		  else if cha{i}='δ֪' then cha{i}='.';
		  else if cha{i}='����' then cha{i}=0;
		  else if cha{i}='����' then cha{i}=1;
		  else if cha{i}='�ֻ�����' then cha{i}=2;
		  else if cha{i}=' ' then cha{i}='.';
	end;
run;
%mend;

%recod(fin_bal,fin_bal_rec);

data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_CC_n = input(F_CC, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_CC;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_CLOAN_n = input(F_CLOAN, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_CLOAN;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_FUND_n = input(F_FUND, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_FUND;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_HLOAN_n = input(F_HLOAN, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_HLOAN;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_MOBILE_n = input(F_MOBILE, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_MOBILE;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_PAYROLL_n = input(F_PAYROLL, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_PAYROLL;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_STAFF_n = input(F_STAFF, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_STAFF;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_TEL_n = input(F_TEL, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_TEL;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_VIP_n = input(F_VIP, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_VIP;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_WEB_n = input(F_WEB, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_WEB;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_YJL_n = input(F_YJL, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_YJL;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    F_YLJ_n = input(F_YLJ, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop F_YLJ;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    CHANNEL_PRE_n = input(CHANNEL_PRE, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop CHANNEL_PRE;
run;
data fin_bal_REC;
    set fin_bal_REC;
    /* ���ַ��ͱ���ת��Ϊ��ֵ�ͱ��� */
    GENDER_n = input(GENDER, best12.); /* ʹ�����ı��������ʵ��ĸ�ʽ */
    /* ɾ��ԭ�ַ��ͱ��� */
    drop GENDER;
run;
data fin_bal_REC;
set fin_bal_REC(rename=(F_CC_n=F_CC));
set fin_bal_REC(rename=(F_CLOAN_n=F_CLOAN));
set fin_bal_REC(rename=(F_FUND_n=F_FUND));
set fin_bal_REC(rename=(F_HLOAN_n=F_HLOAN));
set fin_bal_REC(rename=(F_MOBILE_n=F_MOBILE));
set fin_bal_REC(rename=(F_PAYROLL_n=F_PAYROLL));
set fin_bal_REC(rename=(F_STAFF_n=F_STAFF));
set fin_bal_REC(rename=(F_TEL_n=F_TEL));
set fin_bal_REC(rename=(F_VIP_n=F_VIP));
set fin_bal_REC(rename=(F_WEB_n=F_WEB));
set fin_bal_REC(rename=(F_YJL_n=F_YJL));
set fin_bal_REC(rename=(F_YLJ_n=F_YLJ));
set fin_bal_REC(rename=(CHANNEL_PRE_n=CHANNEL_PRE));
set fin_bal_REC(rename=(GENDER_n=GENDER));
run;
/*��������*/
%let var_list1=C_1W_TR_3  FIX_3  FIX_6  FINACE_3  C_FIANCE_6  GAP_FIANCE_6  FINACE_6 
			C_1W_TR_6  A_L_FIANCE  DT_L_FINACE  DEPOSIT_3  DEPOSIT_6  AGE  AUM_3 
			DEBIT_3  DEBIT_6 FUND_3  AUM_6  FUND_6  CHILDREN  DOB   C_FIANCE_3  GAP_FINACE_3;
/*�������*/
%let cla_list1=F_CC  F_CLOAN   F_FUND   F_HLOAN  F_MOBILE   F_PAYROLL   F_STAFF   F_TEL   F_VIP 
			 F_WEB  F_YJL  F_YLJ  CHANNEL_PRE  GENDER;

/*��ȡѵ���� ��֤��*/
data fin_train_rec fin_valid_rec;
   set fin_bal_REC;
   ran=ranuni(12345);
   if ran<0.7 then output fin_train_rec;
   	else output fin_valid_rec;
   drop ran &miss;
run;



/*�������*/
proc contents data=fin_train_rec;/* ʹ�� PROC CONTENTS ���̲鿴���ݼ��Ľṹ������ */
run;
proc contents data=fin_valid_rec;
run;



/*���Բ������*/
proc means data=fin_train_rec n nmiss mode mean median min  max std;
    var &var_list1;
run;

%macro miss(in_data,out_data);
data &out_data;
    set &in_data;
	if C_1W_TR_3=.    then  C_1W_TR_3 =1.0000000 ;
	if FIX_3=.        then  FIX_3   =70000.00 ;
	if FIX_6=.        then  FIX_6   =60000.00 ;
	if FINACE_3=.     then  FINACE_3   =74725.27 ;
	if C_FIANCE_6=.   then  C_FIANCE_6   =2.0000000 ;
	if GAP_FIANCE_6=. then  GAP_FIANCE_6  =91.0000000 ;
	if FINACE_6=.     then  FINACE_6   =69617.49 ;
	if C_1W_TR_6=.    then  C_1W_TR_6   =1.0000000 ;
	if A_L_FIANCE=.   then  A_L_FIANCE  =100000.00 ;
	if DT_L_FINACE=.  then  DT_L_FINACE  =20171.00 ;
	if DEPOSIT_3=.    then  DEPOSIT_3   =9368.34 ;
	if DEPOSIT_6=.    then  DEPOSIT_6   =10863.97 ;
	if AGE=.          then  AGE    =59.0000000 ;
	if AUM_3=.        then  AUM_3    =22193.60 ;
	if DEBIT_3=.      then  DEBIT_3  =0 ;
	if DEBIT_6=.      then  DEBIT_6   =0 ;
	if FUND_3=.       then  FUND_3     =0 ;
	if AUM_6=.        then  AUM_6     =17229.62 ;
	if FUND_6=.       then  FUND_6     =0 ;
	if CHILDREN=.     then  CHILDREN     =0 ;
	if DOB=.          then  DOB     =3425.00 ;
	if C_FIANCE_3=.   then  C_FIANCE_3    =1.0000000 ;
	if GAP_FINACE_3=. then  GAP_FINACE_3  =9.0000000 ;
	if CHANNEL_PRE=.  then CHANNEL_PRE     =3;
	if GENDER=.       then GENDER    =0;
run;
%mend;

%miss(fin_train_rec, train_nomiss);
%miss(fin_valid_rec, valid_nomiss);


/*�������ݼ� train_nomiss*/
proc means data=train_nomiss n nmiss mode mean median min  max std;
    var &var_list1 ;
run;   

/*�쳣ֵ���� 3sigma*/
proc means data=train_nomiss n nmiss mode mean median min p1 p95 p99 max std;
    var &var_list1;
run;

%macro normal(in_data,out_data);
data &out_data;
	set &in_data;
	C_1W_TR_3=max(min(C_1W_TR_3, 2.0000000), 1.0000000);
	FIX_3=max(min(FIX_3,  500000.00),4709.01);
	FIX_6=max(min(FIX_6, 500811.16),2837.16);
	FINACE_3=max(min(FINACE_3,701538.46),7142.86);
	C_FIANCE_6=max(min(C_FIANCE_6,23.0000000),1.0000000);
	GAP_FIANCE_6=max(min(GAP_FIANCE_6,183.0000000),7.0000000);
	FINACE_6=max(min(FINACE_6,826775.96),6885.25);
	C_1W_TR_6=max(min(C_1W_TR_6,3.0000000),1.0000000);
	A_L_FIANCE=max(min(A_L_FIANCE,1200000.00),48200.00);
	DT_L_FINACE=max(min(DT_L_FINACE,20632.00),17734.00);
	DEPOSIT_3=max(min(DEPOSIT_3,624592.67),0.1800000);
	DEPOSIT_6=max(min(DEPOSIT_6,600228.74),0.2500000);
	AGE=max(min(AGE,87.0000000),24.0000000);
	AUM_3=max(min(AUM_3,1521085.68),0);
	DEBIT_3=max(min(DEBIT_3,350000.00),0);
	DEBIT_6=max(min(DEBIT_6,266666.67),0);
	FUND_3=max(min(FUND_3,322893.50),0);
	AUM_6=max(min(AUM_6,1032059.36),0);
	FUND_6=max(min(FUND_6,228829.39),0);
	CHILDREN=max(min(CHILDREN,0),0);
	DOB=max(min(DOB,5939.00),313.0000000);
	C_FIANCE_3=max(min(C_FIANCE_3,5.0000000),1.0000000);
	GAP_FINACE_3=max(min(GAP_FINACE_3,9.0000000),1.0000000);
run;
%mend;
	
%normal(train_nomiss,train_nomal);
%normal(valid_nomiss,valid_nomal);

proc means data=train_nomal n nmiss mode mean median min p1 p99 max std;
    var &var_list1 ;
run;

/*��׼������*/
/*�鿴�ֲ����*/
proc means data=train_nomal n nmiss mean median min p1 p99 max std;
     var &var_list1;
run;
/*ֱ��ͼ*/
%macro plt(var_name);
proc sgplot data=train_nomal;
    histogram &var_name;
	density &var_name;
	density &var_name
		/type=kernel;
run;
%mend;

%plt(AUM_6);

/*����ƫ������������log�任*/
%let log=FIX_3 FIX_6 FINACE_3  FINACE_6 
			 A_L_FIANCE DT_L_FINACE DEPOSIT_3 DEPOSIT_6 AGE AUM_3 
			DEBIT_3 DEBIT_6 FUND_3 AUM_6 FUND_6 DOB;
/*����ƫ�ļ����ͱ����� sqrt �任 */
%let sqrt=C_1W_TR_3 C_FIANCE_6 C_1W_TR_6  CHILDREN C_FIANCE_3 GAP_FINACE_3 GAP_FIANCE_6; 
%macro std(in_data,out_data);
data &out_data(drop=i j);
     set &in_data;
	 array var1{*} &log;
	 array var2{*} &sqrt;
	 do i=1 to dim(var1);
	    if var1{i} not in ( .,0) then var1{i}=log10(var1{i});
	 end;
	 do j=1 to dim(var2);
	    if var2{j} ^= . then var2{j}=sqrt(var2{j});
	 end;
run;
%mend;

%std(train_nomal,train_std);
%std(valid_nomal,valid_std);

proc means data=train_std n nmiss mode mean median min p1 p95 p99 max std;
    var &var_list1;
run;
%plt(C_1W_TR_3);
%plt(FIX_6);
%plt(FINACE_3);
%plt(C_FIANCE_6);
%plt(GAP_FIANCE_6);
%plt(FINACE_6);
%plt(C_1W_TR_6);
%plt(A_L_FIANCE);
%plt(DT_L_FINACE);
%plt(DEPOSIT_3);
%plt(DEPOSIT_6);
%plt(AGE);
%plt(AUM_3);
%plt(DEBIT_3);
%plt(DEBIT_6);
%plt(FUND_3);
%plt(AUM_6);
%plt(FUND_6);
%plt(DOB);
%plt(C_FIANCE_3);
%plt(GAP_FINACE_3);

/*������ͳ�Ʒ��� ���� CHILDREN Ϊһ���� ��Ҫɸ��  ��Ҫɸѡ�ı�������  36  */
/*�������� 22 */
%let var_list1=FIX_3  FIX_6  FINACE_3  FINACE_6  C_FIANCE_3  C_FIANCE_6  GAP_FINACE_3  GAP_FIANCE_6  
			     C_1W_TR_3  C_1W_TR_6  DEPOSIT_3  DEPOSIT_6  AUM_3  AUM_6  DEBIT_3  DEBIT_6  FUND_3  FUND_6 
                 AGE  DOB  A_L_FIANCE  DT_L_FINACE;
/*������� 14 */
%let cla_list1=F_CC  F_CLOAN  F_FUND  F_HLOAN  F_MOBILE  F_PAYROLL  F_STAFF  F_TEL  F_VIP 
			F_WEB  F_YJL  F_YLJ  CHANNEL_PRE  GENDER;
			
/*���ݹ�����ɸ������*/
/*��ط��� corr*/
/*���������������*/
proc corr data=train_std spearman;
	var target &cla_list1;
    with &var_list1;
run;
/* ����������CSV�ļ����Ա�����excel�л�������ͼ ֻ�ܱ������� */
/*
ods csv file="corr_spearman.csv";
proc print data=_LAST_ (obs=max);
run;
ods csv close;
*/

/*�����������������*/
proc corr data=train_std pearson;
	var &var_list1;
run;
/* ��Pearson���ϵ����������CSV�ļ� ֻ�ܱ������� */
/*
ods csv file="corr_pearson.csv";
proc print data=_LAST_ (obs=max);
run;
ods csv close;
*/

*���������������;
%macro freq1(char1,char2);
proc freq data=train_std;
	table &char1*&char2
		/chisq;
run;
%mend;

%freq1(F_CLOAN,F_HLOAN);

/*VIF����*/
proc reg data=train_std;
     model target=&var_list1 &cla_list1
	/vif;
run;

*ɸ�����й����Եı���;
%let gx=FIX_3 C_FINACE_3 C_FINACE_6 GAP_FINACE_3 DEPOSIT_3 DEPOSIT_6 
         AUM_3 DEBIT_3 DT_L_FINACE FUND_3 FUND_6 FINACE_3 C_1W_TR_3 ;
*��Ҫɸѡ�ı�����: 23;
/*�������� 9 */
%let var_list2= FIX_6  FINACE_6 GAP_FIANCE_6 C_1W_TR_6  AUM_6 DEBIT_6 AGE DOB A_L_FIANCE ;
/*������� 14 */
%let cla_list2=F_CC F_CLOAN F_FUND F_HLOAN F_MOBILE F_PAYROLL F_STAFF F_TEL F_VIP 
			F_WEB F_YJL F_YLJ CHANNEL_PRE GENDER;
			
/* �෽����϶Ա�ɸѡ���� */
/*��ط��� corr*/
*target--&var_list2;
proc corr data=train_std spearman;
	var target; 
    with &var_list2;
run;
*target--&cla_list2;
proc freq data=train_std;
	table (&cla_list2)*target
        /chisq nocol nopercent;
run;

/*�𲽻ع鷨ɸѡ����*/
proc logistic data=train_std descending namelen=50;
     model target(event='1')=&var_list2 &cla_list2
	 /selection=stepwise 
		sls=0.05  sle=0.05
		stb  lackfit  parmlabel;
run;

/*4������ROC���߸�����������Ϣ�ٷֱ� ɸѡ����*/
proc logistic data=train_std plots=roc;
    class &cla_list2;
	model target(event='1')=&var_list2 &cla_list2/ctable;
    ROC  "FIX_6"         FIX_6;
	ROC  "FINACE_6"      FINACE_6;
	ROC  "GAP_FIANCE_6"  GAP_FIANCE_6;
	ROC  "C_1W_TR_6"     C_1W_TR_6;
	ROC  "AUM_6"         AUM_6;
	ROC  "DEBIT_6"       DEBIT_6;
	ROC  "AGE"           AGE;
	ROC  "DOB"           DOB;
	ROC  "A_L_FIANCE"    A_L_FIANCE;
	ROC  "F_CC"          F_CC;
	ROC  "F_CLOAN"       F_CLOAN;
	ROC  "F_FUND"        F_FUND;
	ROC  "F_HLOAN"       F_HLOAN;
	ROC  "F_MOBILE"      F_MOBILE;
	ROC  "F_PAYROLL"     F_PAYROLL;
	ROC  "F_STAFF"       F_STAFF;
	ROC  "F_TEL"         F_TEL;
	ROC  "F_VIP"         F_VIP;
	ROC  "F_WEB"         F_WEB;
	ROC  "F_YJL"         F_YJL;
	ROC  "F_YLJ"         F_YLJ;
	ROC  "CHANNEL_PRE"   CHANNEL_PRE;
	ROC  "GENDER"        GENDER;
run;

*�������� ���ϵ�� �𲽻ع� ROC������ɸѡ����Ա�
ѡ����ͬ��Ϊ��Ҫ�ı���, ��������ı������η���ģ�Ͳ鿴ģ�;����Ƿ��������仯��������������޳�;
ods graphics on;
proc logistic data=train_std plots(MAXPOINTS=5000)=roc;
  class &cla_list2;
  model target(event='1')=&var1;
run;
ods graphics off;

/*AUMֵҲ�����ʲ������ģ����ָ�������ڻ����ʲ�����ҵ���ģ��ָ�꣬�Ǹ����е�ǰ����ͻ��ʲ�������ֵ��*/

/*����80.74%��ȷ������ģ���еı���Ϊ: 7*/
%let var2=AUM_6  CHANNEL_PRE  AGE  GAP_FIANCE_6  F_WEB  DOB  GENDER;    
 
/*ģ�͵Ľ���������*/
/*��ѵ��������ģ�� �������֤�� ��� ���� ����*/
/*ROC�������*/
ods graphics on;
proc logistic data=train_std outmodel=fin_model plots(MAXPOINTS=5000)=roc;
	 class CHANNEL_PRE F_WEB GENDER;
	 model target(event='1')=&var2
		/pprob=0.33 ctable;
	 score out=train_score;
run;
proc logistic data=valid_std plots(MAXPOINTS=5000)=roc;
    class CHANNEL_PRE F_WEB GENDER;
	model target(event='1')=&var2;
run;
ods graphics off;

/*����ģ�� ����֤������ģ����� ����*/
proc logistic inmodel=fin_model;
    score data=valid_std out=valid_score
	 priorevent=0.33;      *�������������Ԥ������target=1��ռ�ȿɵ���;
run;
/*ѵ��������֤�� Ԥ��������������Ա�*/
%macro f_i(data);
proc freq data=&data;
   table f_target*i_target;
run;
%mend;
%f_i(train_score);
%f_i(valid_score);

/*����ģ�͸��������Ȼ���Ʒ����� ȷ��������ϵ��,��ģ�;��廯*/
proc logistic data=train_std outmodel=fin_model;
	 class CHANNEL_PRE F_WEB GENDER;
	 model target(event='1')=&var2;
run;

/*����ģ�� ����֤���÷����� ����ҵ������ ���������Ϊ���� �������ĵ����жϿͻ��Ƿ���Ӧ����ֵ*/
proc logistic inmodel=fin_model;
     score data=valid_std out=valid_score
	 priorevent=0.33;         
run;
proc freq data=valid_score;
	table f_target*i_target;
run;

*������� priorevent Ϊԭʼ���ݼ��������������ȡ���ľ������ݼ����� �¼� target=1 ��ռ��
�ɸ��ݾ���ҵ�� ��˾��� ���������Ϊ���� ������ֵ���������ֵָ����Ԥ������ target=1 ��ռ�ȣ�
�� ������ҵ�� ���ſͻ��� �ɵ��߸���ֵ����֮����;

/*3�����廯����ģ�ͽṹ�и�������ģ��Ԥ������Ӱ��*/
*����������ֱ��ͨ����������Խ�����Ӧ��Ӱ�죬Ҳ���Խ������������� �磺age ��ɢ��֮������ڽ��ͣ�
���������ͨ�������Աȸ�����ˮƽ��target=1��0 ��ռ�� ��һ��������һ��ˮƽ�Ŀͻ���������Ӧ����Ӧ��
Ҳ���ԶԷ���������Ʊ����任����ÿһ����Ϊһ�������ı����������Ƚϸ����Ʊ�����ģ�͵Ĺ��׶�;

/*̽�������������һ����п��ܹ������Ʋ�Ʒ*/
proc freq data=train_std;
    table target*(CHANNEL_PRE gender F_WEB )/chisq;
run;
/*Ϊ�˸����ڽ�������������ģ�͵�Ӱ�죬�Բ�����������������ɢ������̽���������������ı仯����Ӧ���ʵı仯���ƣ�*/
%macro lift_var(in_data,Var_group,n_group);
proc sort data=&in_data out=fin_sort;
   by &var_group;
run;
*��ӷ����� һ������ 10��;
data fin_group;
   set fin_sort;
   group=ceil(_N_/&n_group);
run;
*���ݷ��� ���ÿ���pֵ   pֵ=ÿ����ʵ��targetΪ1��ռ�ȳ����������ݼ���targetΪ1��ռ��;
data fin_plt_lift;
    set fin_group;
	by group;
	if first.group then sum=0;
	sum + target;
	avg=sum/&n_group;
	if last.group;
run;
*����liftͼ;
proc sgplot data=fin_plt_lift;
    series x=group y=avg/markers;
run;
%mend;
%let var2=AUM_6 CHANNEL_PRE F_WEB DOB AGE GAP_FIANCE_6 GENDER ;
%lift_var(train_std,age,4628);  %lift_var(valid_std,age,2042);
%lift_var(train_std,DOB,4628);  %lift_var(valid_std,DOB,2042); 
%lift_var(train_std,GAP_FIANCE_6,4628);  %lift_var(valid_std,GAP_FIANCE_6,2042); 
%lift_var(train_std,AUM_6,4628);  %lift_var(valid_std,AUM_6,2042); 



