Select * from Bank_Data;

------- Total numbers of applications received

Select count(member_id) as Total_applications_received
from Bank_Data;

------- month to date loan amount
select SUM(loan_amount) as 'MTD Total Funded amount'
from Bank_Data
Where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;

----- PMTD Loan amount

Select SUM(loan_amount) as 'PMTD Total funded amount'
from Bank_Data
Where month(issue_date) =11 and YEAR(issue_date) = 2021;

------ Total Received amopunt to bank

select SUM(total_payment) as 'Total Amount Received'
from Bank_Data;  

------ Total received for current month and previous month
Select SUM(total_payment) as 'MTD amount received'
from Bank_Data
Where MONTH(issue_date) =12  and YEAR(issue_date) = 2021;

Select SUM(total_payment) as 'PMTD amount received'
from Bank_Data
Where MONTH(issue_date) = 11 and Year(issue_date) = 2021;

------ Total interest Rate 
Select Format(AVG(int_rate) ,'P','en-GB') as 'Avg interest rate'
from Bank_Data;

-------- MTD interest rate and PMTD
Select Format(AVG(int_rate) ,'P','en-GB') as ' MTD Avg interest rate'
from Bank_Data
Where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021
;

Select Format(AVG(int_rate) ,'P','en-GB') as ' PMTD Avg interest rate'
from Bank_Data
Where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021
;

-------- avg of DTI
Select Format(AVG(dti),'P','en-GB')  as 'Avg DTI'
from Bank_Data;

--------- Avg DTI for MTD and PMTD
Select Format(AVG(dti),'P','en-GB')  as 'MTD Avg DTI'
from Bank_Data
Where MONTH(issue_date) = 12 and YEAR(issue_date)= 2021;

Select Format(AVG(dti),'P','en-GB')  as 'PMTD Avg DTI'
from Bank_Data
Where MONTH(issue_date) = 11 and YEAR(issue_date)= 2021;

------- Goodloan vs Badloan 

Select Format((Count(Case when loan_status = 'Fully Paid' OR loan_status = 'Current' Then id END)* 1.0
/
COUNT(id)),'P', 'en-GB') as Good_loan_percentage
from Bank_Data;----- good loan percentage
 
select count(id) as Good_loan_application from Bank_Data
where loan_status = 'Fully paid' or loan_status= 'Current'; --- finding total good loan applicstions

select Format(sum(loan_amount),'c','en-US') as Good_loan_fundedamount from Bank_Data
where loan_status = 'Fully paid' or loan_status= 'Current';---- total good loan funded amount

select sum(total_payment) as Good_loan_received_amount from Bank_Data
where loan_status = 'Fully paid' or loan_status= 'Current'; ----- total good loan received amount

Select Format((Count(Case when loan_status = 'Charged off' Then id END)* 1.0
/
COUNT(id)),'P', 'en-GB') as Bad_loan_percentage
from Bank_Data; ----- Total Bad Loan Percentage

select count(id) as Bad_loan_application from Bank_Data
where loan_status = 'Charged off';  ------- total bad loan applications

select Format(sum(loan_amount),'c','en-US') as Bad_loan_funded_amount from Bank_Data
where loan_status = 'Charged off'; ----- total bad loan funded amount

select format(sum(total_payment),'c','en-US') as Bad_loan_writeoff_amount from Bank_Data
where loan_status = 'Charged off'; ----- written off amount 


------- loan status

select loan_status,
       count(id) as Total_applications,
       Format(sum(total_payment),'c','en-US') as Total_amount_received,
	   Format(sum(loan_amount),'c','en-US') as total_funded_amount,
	   Format(AVG(int_rate ),'p') as interest_rate,
	   Format(AVG(dti ),'P') as DTI
	   from Bank_Data
	   group by
	   loan_status;

 ----- MTD loan status

  select loan_status,
       Format(sum(total_payment),'c','en-US') as Total_amount_received,
	   Format(sum(loan_amount),'c','en-US') as total_funded_amount
	   from Bank_Data
	   where MONTH(issue_date) = 12 
	   Group by loan_status;


 -------- monthly trends
   Select DATENAME(month, issue_date) as Month,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   where MONTH(issue_date) <= 12
   group by DATENAME(month, issue_date), MONTH(issue_date)
   order by month(issue_date) asc;

  ---- regional analysis by state 

  select address_state,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   group by address_state
   order by address_state;

   ----- total amount by term 
   Select term,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   group by term
   order by term;

   ------ total applications by emp length
      Select emp_length,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   group by emp_length
   order by count(id) desc;

   ------- total applications by purpose 
    Select purpose,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   group by purpose
   order by count(id) desc;

--------- total appplications by home ownership

   Select home_ownership,
   count(id) as 'total loan Applications',
   format(sum(loan_amount),'c','en-US') as 'Total funded Amount',
   format(sum(total_payment),'c','en-US') as 'total received amount'
   from Bank_Data
   group by home_ownership
   order by count(id) desc;
