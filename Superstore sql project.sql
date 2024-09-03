--SuperStore Data sales
Skills Used: converting datatype, Renaming Column,Joins,Group by,CTE, Aggregate Fumctions, Creating views, Creating Stored Procedures
Select * from Orders
Select * from People
select * from Returns

-- changing datetime datatype to date
Alter table Orders
Alter Column Order_Date date;

-- changing datetime datatype to date
Alter Table Orders
Alter Column Ship_Date date;

-- Renaming the column
exec sp_rename 'Orders.Ship Mode', 'Ship_Mode';
exec sp_rename 'Orders.Ship Date', 'Ship_Date';


-- Total Price by Market and Category
-- Shows the price of the category in each market
select Orders.Market,Orders.Category, 
sum(Orders.Unit_Price*Orders.Quantity) As 'Total Price'
from Orders
Group by  Orders.Market,Orders.Category;

-- Shipping Cost by Order date and ship date 
-- it shows the orders details like order id , when order is place and ship date with shipping mode and the cost of it
Select Orders.[Order _ID],Orders.Order_Date,Orders.Ship_Date,Orders.Ship_Mode,Orders.Shipping_Cost
from Orders
Group by Orders.[Order _ID], Orders.Order_Date,Orders.Ship_Date,Orders.Ship_Mode,Orders.Shipping_Cost
Order by Orders.Order_Date asc;

-- stored procedure for  Shipping cost by order date and ship date using string split for ship mode column
-- it shows the same data like the top query but using string split we are splitting the ship mode data

create proc spgetshippingcostby_mode
@ship_mode nvarchar(200)
as
begin
Select Orders.[Order _ID],Orders.Order_Date,Orders.Ship_Date,Orders.Ship_Mode,Orders.Shipping_Cost
from Orders 
where Orders.Ship_Mode in(select * from string_split(@ship_mode,','))
Group by Orders.[Order _ID], Orders.Order_Date,Orders.Ship_Date,Orders.Ship_Mode,Orders.Shipping_Cost
Order by Orders.Order_Date asc
end;

exec spgetshippingcostby_mode @ship_mode='Standard Class';
exec spgetshippingcostby_mode @ship_mode='second Class';

-- segment sold by person in each city
-- shows the segment sold by each person in the city
select Orders.[Order _ID],Orders.Order_Date,Orders.Segment,Orders.City,
People.Person
from Orders
join People
on Orders.Region=People.Region
order by Orders.City asc;

-- customers vs total order amount 
--shows the customers by city with unit price, quantity, discount and total price

select Orders.[Order _ID],Orders.[Customer _Name], Orders.City, Orders.Unit_Price,Orders.Quantity,Orders.Discount,
sum(Orders.Unit_Price*Orders.Quantity) As 'Total Price'
from Orders
group by  Orders.[Order _ID],Orders.[Customer _Name], Orders.City,Orders.Unit_Price,Orders.Quantity,Orders.Discount
Order by Orders.City asc;

-- sub category and quantity by State and city

select Orders.[Order _ID], Orders.Category, Orders.Quantity,Orders.City,Orders.State
from Orders
group by Orders.[Order _ID],Orders.Category,Orders.Quantity, Orders.City,Orders.State
Order by Orders.State asc;

-- States with highest sale by category
Select Orders.Order_Date, Orders.State, Orders.Category, max(Orders.Unit_Price*Orders.Quantity) As 'Highest Price'
from Orders
group by Orders.Order_Date,Orders.State, Orders.Category
Order by Orders.Order_Date asc;

 -- Customers , Category and Quantity  by Order priority using string_split

Create proc spgetOrder_PrioritybyCustomer
@Order_Priority nvarchar(200)
as
begin
select Orders.[Customer _Name],Orders.Category,Orders.Quantity,Orders.Order_Priority,Orders.Market
from Orders
where Orders.Order_Priority in(select * from string_split(@Order_Priority,','))
group by Orders.[Customer _Name],Orders.Category,Orders.Quantity,Orders.Order_Priority,Orders.Market
order by Orders.Quantity desc
end;

exec spgetOrder_PrioritybyCustomer @Order_Priority='Low';

--shows total price and profit by category and sub-category With CTE and creating view for the query 
Create view categoryandsubcategorysales
as
With Avgprofit as(
Select AVG(Orders.Profit) as Avg_profit
From Orders
)
select  Orders.Order_Date,Orders.Category,Orders.[Sub-Category]
,sum(Orders.Unit_Price*Orders.Quantity) As Total_Price,
Orders.Profit
from Orders
Where Orders.Profit > ( select Avg_profit from Avgprofit)
group by  Orders.Order_Date,Orders.Category,Orders.[Sub-Category],Orders.Profit;

Select * from categoryandsubcategorysales; 

-- No of returned customers using Three tables and inserting view in the query 
-- Using Select Distinct to elminate duplicates

 select  Distinct  categoryandsubcategorysales.Order_Date,  Orders.[Customer _Name], People.Region,Returns.Returned,
 categoryandsubcategorysales.Total_Price
from Orders
 join People
On Orders.Region = People.Region
 join Returns
on People.Region= Returns.Region
join categoryandsubcategorysales 
on categoryandsubcategorysales.Order_Date = Orders.Order_Date;