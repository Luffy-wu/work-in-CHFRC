function deal_0811_fund_f()
[~,txt,raw]=xlsread('C:\Users\asus\Desktop\实习luffy1\0727\指数基金.xls','changch300nav');   %以上证50为例
[m_total,n_total] = size(raw);
day = 0;
m_all=fix(m_total/5);
data_out = cell(m_all,n_total); %为新表格申请空间
data_out(1,:) = raw(1,:);       %第一行相同，都是列的名称
j=2;
% for i=2:m_all
%     data_out(i,2)={0};
%     data_out(i,3)={0};
% end                             %初始化
sign=1;
for i=2:m_total
%     temp1=raw{i,1};
%     temp=datevec(temp1);
%     year_temp = temp(1);
%     month_temp = temp(2);
%     day_temp = temp(3);
   temp2=num2str((raw{i,1}));
    day_temp=temp2(7:8);
     year_temp=temp2(1:4);
     month_temp=temp2(5:6);
     date=strcat(year_temp,'-',month_temp,'-', day_temp);
     day_temp=str2num(day_temp);
   if(day <= day_temp)           %因为交易日的特殊性，当月的最后一个交易日一定大于次月的交易日。
       day= day_temp;
       [~, Dayname] =weekday(date);
       if(Dayname =='Fri' & sign==1)
       data_out{j,1}=raw{i,1};
       data_out{j,2}=raw{i,2};  
       j=j+1;
       sign=0;
       end
   else        %若大于，则说明进入到次月
       sign=1;        
       day= day_temp;
        [~, Dayname] =weekday(date);
       if(Dayname =='Fri' & sign==1)
       data_out{j,1}=raw{i,1};
       data_out{j,2}=raw{i,2};  
       j=j+1;
       sign=0;
       end
   end
end
b=0;
j=j-1;
a=zeros(j-1,1);
for i=1:j-1
    c=data_out{j,2};
    d=data_out{1+i,2};
    a(i)=1000*c/d;
    b=b+a(i);
end
syms x;
eq=1015*((1+x)^(j-1)-1)/x-b; %20170731xiugai，eq=1006.02*((1+x)^(j-1)-1)/x-b*(1-0.01*0.134);
x=solve(eq,'x');
ans=double(x);
ans=ans(~logical(imag(ans)));
c=ans(ans>0);

syms y;
eq=1015*((1+y)^(j-1)-1)/y-(b-197.8487255); %20170731xiugai
y=solve(eq,'y');
ans=double(y);
ans=ans(~logical(imag(ans)));
c2=ans(ans>0);

xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\changch300nav_f.xls',data_out,'sheet1');
xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\changch300nav_f.xls',c,'sheet2');
xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\changch300nav_f.xls',c2,'sheet3');