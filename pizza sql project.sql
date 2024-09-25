 ------Skills used: Aggregate functions, Windows functions, Format function, group by, cast function, stored procedures, views  

Select * from pizza_sales;

-------- Total Revenue in a year in $

select Format(SUM( total_price),'c','en-US') as 'Total Revenue'
from pizza_sales;

--------Average order value 
select Format( SUM( total_price)/count(distinct order_id),'c','en-US') as 'Avg Order value'
from pizza_sales;

-------- Total Pizzas sold
select SUM(quantity) as 'Total Pizzas Sold'
from pizza_sales;

-------- Total Orders Placed

select count(Distinct order_id) as 'Total Orders' from pizza_sales;

--------- avg pizzas per order

Select CAST(CAST(sum(quantity) as decimal(10,2))/CAST(Count( Distinct order_id)as decimal(10,2)) as decimal(10,2)) 
as ' avg Pizzas Per Order'
from pizza_sales;

--------- Daily trend for total orders
   
   Select DATENAME(DW, order_date) as order_date, COUNT(DISTINCT order_id) as 'Total Orders'
   from pizza_sales
   group by DATENAME(DW,order_date);

---------- Hourly Trend

Select DATEPART(HOUR,order_time) as 'orders hour', COUNT(DISTINCT order_id) as 'Total Orders'
from pizza_sales
group by DATEPART(HOUR,order_time)
order by DATEPART(HOUR,order_time);
  

------- total sales % of sales by pizza category

 Select pizza_category, Format(CAST(sum(total_price) as decimal(10,2)),'c','en_US') as 'Total sales', CONCAT(CAST(sum(total_price)*100 / 
 (Select SUM(total_price) from pizza_sales  where month(order_date) =2)  as decimal(10,2)),'%')
 as '% of sales by Category'
 from pizza_sales
 where month(order_date) =2
 group by pizza_category;


---- % of pizza sales by pizza size
 Select pizza_size, Format(CAST(sum(total_price) as decimal(10,2)),'c','en_US') as 'Total sales', CONCAT(CAST(sum(total_price)*100 / 
 (Select SUM(total_price) from pizza_sales  where month(order_date) =2)  as decimal(10,2)),'%')
 as '% of sales by Category'
 from pizza_sales
 where month(order_date) =2 --- fot qtr datepart(quarter, order_date)=1
 group by pizza_size
 ;

--- total pizzas sold by pizza category

select  pizza_category,sum(quantity) 'Total quantity'
from pizza_sales
group by pizza_category;

---- top 5 pizzas

select top 5 pizza_name, sum(quantity) as 'most pizza sold'
from pizza_sales
group by pizza_name
order by 'Top pizza sold' desc;

----worst 5 pizzas

select top 5 pizza_name, sum(quantity)as 'least pizzas sold'
from pizza_sales
group by pizza_name
order by 'least pizzas sold' asc;

--------- creating views with hourly trend 

  Create view  viewhourlytrend
as
Select DATEPART(HOUR,order_time) as 'orders hour', COUNT(DISTINCT order_id) as 'Total Orders'
from pizza_sales
group by DATEPART(HOUR,order_time);

select *from viewhourlytrend;

---------- % of pizza sales by pizza size by using stored proc with and without parameters

create proc spgetpizza_sales_by_sizess
@MONTH nvarchar(250)
as
begin
 Select pizza_size,
 Format(CAST(sum(total_price) as decimal(10,2)),'C','en_US') as 'Total sales', 
 CONCAT(CAST(sum(total_price)*100.0 / (Select SUM(total_price) 
 from pizza_sales  where  MONTH(order_date) in(select * from string_split(@MONTH,','))) as DECIMAL(10,2)),'%')
 as '% of sales by Category'
 from pizza_sales
 where  MONTH(order_date) in(select * from string_split(@MONTH,',')) --- fot qtr datepart(quarter, order_date)=1
 group by pizza_size
 end;
 
 exec spgetpizza_sales_by_sizess @MONTH=2;

 ----- with parameters
 Create proc spgetpizza_sales_by_size 
 as
 begin 
 select 
 pizza_size,
 format(CAST(sum(total_price) as decimal(10,2)),'c','en-US') as Total_sales
 from pizza_sales
 where MONTH(order_date) in (1,2,3) 
 group by pizza_size;
 end;

 exec spgetpizza_sales_by_size;