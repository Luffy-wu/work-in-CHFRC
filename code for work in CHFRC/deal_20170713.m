function deal_20170713()
[~,txt,raw]=xlsread('C:\Users\asus\Desktop\M\上证50.xls','50'); %以上证50为例
[m_total,n_total] = size(raw);
day = 0;
m_all=fix(m_total/10);
data_out = cell(m_all,n_total); %为新表格申请空间
data_out(1,:) = raw(1,:);       %第一行相同，都是列的名称
j=2;
daynumber=0;                    %用于记录每月对应的天数
for i=2:m_all
    data_out(i,2)={0};
    data_out(i,3)={0};
end                             %初始化
for i=2:m_total
    temp=txt{i};
    temp=datevec(temp);
    year_temp = temp(1);
    month_temp = temp(2);
    day_temp = temp(3);
   if(day < day_temp)           %因为交易日的特殊性，当月的最后一个交易日一定大于次月的交易日。（主力合约未出现停牌等现象）
       data_out{j,2}=data_out{j,2}+raw{i,2};
       data_out{j,3}=data_out{j,3}+raw{i,3};
       daynumber=daynumber+1;
       temp1=temp;
       temp1(1)=year_temp;
       temp1(2)=mod(month_temp+1,12); %由于将天数隐去，用datestr函数整体月份往前推了一月，因而这里将月份往后延一个月
       temp1(3)=0;                    %将天数隐去
       temp2=datestr(temp1,'yyyy-mm');
       data_out{j,1}= temp2;
       day= day_temp;
   else                              %若大于，则说明进入到次月
       data_out{j,2}=data_out{j,2}/daynumber;   %特定月的各日股指的收盘价之和除以天数，得月平均收盘价
       data_out{j,3}=data_out{j,3}/daynumber;   %特定月的各日股指期货的收盘价之和除以天数，得月平均收盘价
       daynumber=1;
       j=j+1;
       day= day_temp;
       data_out{j,2}=raw{i,2};
       data_out{j,3}=raw{i,3};
   end
end
data_out{j,2}=data_out{j,2}/daynumber;   %将最后一个月平均化
data_out{j,3}=data_out{j,3}/daynumber;
xlswrite('C:\Users\asus\Desktop\M\713上证50已处理.xls',data_out,'sheet1');