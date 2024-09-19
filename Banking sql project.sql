
------Skills Used: Changing datatype, Aggregate Functions, Views, Stored Procedures, Format Function, String_split function,Group by
Select * from UK_Bank_Customers

--- changing data type from varchar to int
Alter Table UK_Bank_Customers
Alter Column Age int;

------- count of gender from each region and their balance by Date_Joined

Select Date_Joined,Region, AVG(Age) as 'Avg Age',
SUM(case when Gender = 'Male' then 1 else 0 end) as 'Male count',
Sum(Case when Gender = 'Female' Then 1 else 0 end) as 'Female count',
Format(sum(case when Gender = 'Male' Then Balance else 0 end),'C','en-GB') as'Total Male Balance',
Format(Sum(Case when Gender = 'Female' Then Balance else 0 End), 'C', 'en-GB') as 'Total Female Balance'
from UK_Bank_Customers
group by Region,Date_Joined
Order by Region asc ;

--------Account balance by gender, job classification using stored procedure without parameters using stringsplit function

Create procedure spgetbalanceandjobclassification
@Job_Classification nvarchar(2500), @Region nvarchar(2500)
as
begin 
select Job_Classification, Region,
sum(Balance) as 'Total Balance'
from UK_Bank_Customers
where Job_Classification   is not null 
 and Region is not null and Job_Classification   in( select * from 
string_split(@Job_Classification,',')) and  Region in(select * from string_split(@Region,',') )
group by Job_Classification, Region
end
;
exec  spgetbalanceandjobclassification
@Job_Classification = 'White Collar,Blue Collar' , @Region = 'England,Wales';
drop proc spgetbalanceandjobclassification;

------------- creating views for gender and age
Create View Gender_total 
as
Select  Gender,count(*) as 'total number', Job_Classification, avg(Age) as 'Avg age', Region
from UK_Bank_Customers
Where Job_Classification in ('White Collar', 'Blue Collar')
group by Gender,Job_Classification ,Region
;
select * from  Gender_total ;
drop view Gender_total;

----------- including stored procedure and view in a single query by creating temp table

Create procedure spgetbalanceandjobclassificationview
@Job_Classification nvarchar(2500), @Region nvarchar(2500)
as
begin 
---- step1: calculates total balance for specified job classifications and Regions

  select Job_Classification, Region,
  Sum(Balance) as 'Total_Balance'
  into #TempResult
  from UK_Bank_Customers
  Where Job_Classification is not null And Region is not null
  And Job_Classification
  in (Select Value from string_split(@Job_Classification,','))
  and  Region in(select * from string_split(@Region,',') )
group by Job_Classification, Region;
-- step2: join the temp table with the view to get gender based statistics and average age

select t.Job_Classification, t.Region, t.Total_Balance, v.Gender, v.[total number], v.[Avg age]
from #TempResult t
join  Gender_total v
on t.Region = v.Region
And t.Job_Classification = v.Job_Classification
Order by 
t.Region, v.Gender, t.Job_Classification;
-- cleans up the data after use
drop table #TempResult;
end;

exec  spgetbalanceandjobclassificationview
@Job_Classification = 'White Collar,Blue Collar' , @Region = 'England,Wales';

drop proc spgetbalanceandjobclassificationview

------- no of customers joined each date, balance on each date and storing the data in a temp table

select  Date_Joined,count(Customer_ID) as 'No of Customers',
Region,FORMAT(sum(Balance),'c', 'en-GB') as 'Each day amount'-- to show balance with currancy symbol
into #TepmDataas
from UK_Bank_Customers
group by Date_Joined,Region
order by Date_Joined asc;

select * from #TepmDataas;

drop table #TepmDataas;

---------- Account balance by gender, job classification

Select Job_Classification, Gender,
Sum(Balance) as 'Total Balance'
from UK_Bank_Customers
Where Gender= 'Male'
Group by Job_Classification,Gender;

Select Job_Classification, Gender,
Sum(Balance) As 'Total Balance'
from UK_Bank_Customers
Where Gender= 'Female'
Group by Job_Classification,Gender;


