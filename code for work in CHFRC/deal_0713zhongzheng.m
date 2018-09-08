function deal_0713zhongzheng()
[~,txt,raw]=xlsread('C:\Users\asus\Desktop\M\中证500.xls','500');
[m_total,n_total] = size(raw);
day = 0;
m_all=fix(m_total/10);
data_out = cell(m_all,n_total);
data_out(1,:) = raw(1,:);  
j=2;
daynumber=0;
for i=2:m_all
    data_out(i,2)={0};
    data_out(i,3)={0};
end
for i=2:m_total
    temp=txt{i};
    temp=datevec(temp);
    year_temp = temp(1);
    month_temp = temp(2);
    day_temp = temp(3);
   if(day < day_temp)
       data_out{j,2}=data_out{j,2}+raw{i,2};
       data_out{j,3}=data_out{j,3}+raw{i,3};
       daynumber=daynumber+1;
       temp1=temp;
       temp1(1)=year_temp;
       temp1(2)=mod(month_temp+1,12);
       temp1(3)=0;
       temp2=datestr(temp1,'yyyy-mm');
       data_out{j,1}= temp2;
       day= day_temp;
   else
       data_out{j,2}=data_out{j,2}/daynumber;
       data_out{j,3}=data_out{j,3}/daynumber;
       daynumber=1;
       j=j+1;
       day= day_temp;
       data_out{j,2}=raw{i,2};
       data_out{j,3}=raw{i,3};
   end
end
data_out{j,2}=data_out{j,2}/daynumber;
data_out{j,3}=data_out{j,3}/daynumber;
xlswrite('C:\Users\asus\Desktop\M\713中证500已处理.xls',data_out,'sheet1');