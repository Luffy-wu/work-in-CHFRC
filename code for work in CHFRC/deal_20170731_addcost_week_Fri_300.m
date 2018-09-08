function deal_20170731_addcost_week_Fri_300()
[~,txt,raw]=xlsread('C:\Users\asus\Desktop\实习luffy1\0727\指数原始数据2.xls','300');   %hushen100
[m_total,n_total] = size(raw);
day = 0;
m_all=fix(m_total/5);
data_out = cell(m_all,n_total); %为新表格申请空间
data_out(1,:) = raw(1,:);       %第一行相同，都是列的名称
j=2;
sign=1;
for i=2:m_total
%     temp1=raw{i,1};
%     temp=datevec(temp1);
%     year_temp = temp(1);
%     month_temp = temp(2);
%     day_temp = temp(3);
%     temp00=raw{i,1};
%      [~, temp01] =weekday(temp00);
%     temp000=datevec(raw{i,1});
%     temp001 = datestr(temp000,'dd-mmm-yyyy');
%     [~,Dayname] =weekday(temp001);
%     %上面是刚加的
    temp2=num2str((raw{i,1}));
    day_temp=temp2(7:8);
     year_temp=temp2(1:4);
     month_temp=temp2(5:6);
     date=strcat(year_temp,'-',month_temp,'-', day_temp);
     day_temp=str2num(day_temp);
   if(day < day_temp)           %因为交易日的特殊性，当月的最后一个交易日一定大于次月的交易日。
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
% data_out{j,1}=raw{i,1};
% data_out{j,2}=raw{i,2}; 
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
eq=1000*((1+x)^(j-1)-1)/x-b;
x=solve(eq,'x');
ans=double(x);
ans=ans(~logical(imag(ans)));
c=ans(ans>0);
% %这下面是新写的,用于求单个的值
% yearrate=0.03393;
% monthrate=(1+yearrate)^(1/12)-1;
% b1=0;
% a=zeros(j-1,1);
% for i=1:j-1
%      a(i)=1000/((1+monthrate)^(i-1));
%      b1=b1+a(i);
% end
% syms r;
% eq=b1*(1+r)^(j-2)-b;
% r=solve(eq,'r');
% ans1=double(r);
% ans1=ans1(~logical(imag(ans1)));
% r0=ans1(ans1>0);

%这下面是敏感性分析
yearrate=0.03393;
monthrate=(1+yearrate)^(1/12)-1;
n=20;
r1=zeros(n,1);
i1=1;
for monthrate1=(monthrate-0.01*0.1*2/n):0.00001:(monthrate+0.01*0.1*2/n)
    b1=0;
    a=zeros(j-1,1);
  for i=1:j-1
     a(i)=1006.02/((1+monthrate1)^(i-1)); %20170731修改
     b1=b1+a(i);
  end
syms r;
b1=b1+0.134*0.01*b/((1+monthrate1)^(j-2));%考虑卖出费用时
eq=b1*(1+r)^(j-2)-b;
r=solve(eq,'r');
ans1=double(r);
ans1=ans1(~logical(imag(ans1)));
r1(i1)=ans1(ans1>0);
i1=i1+1;
end  %注意有21个
 monthrate2=(monthrate-0.01*0.1*2/n):0.00001:(monthrate+0.01*0.1*2/n);
xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\沪深300已处理_addcost_week_Fri2.xls',data_out,'sheet1');
xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\沪深300已处理_addcost_week_Fri2.xls',r1,'sheet2');
xlswrite('C:\Users\asus\Desktop\实习luffy1\0727\沪深300已处理_addcost_week_Fri2.xls',monthrate2,'sheet3');