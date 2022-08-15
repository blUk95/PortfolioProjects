


--1.
--Write a query which gives the total amount invested, the cancelled amount and the paid amount per day in 2021.

With a_invest as (Select date_invested,
SUM(CASE when investment_status = 'paid' THEN amount_in_gbp END) as Total_Paid,
SUM(CASE when investment_status = 'cancelled' THEN amount_in_gbp END) as Total_Cancelled
From cc_investments
group by date_invested)

Select a_invest.date_invested, a_invest.Total_Paid, a_invest.Total_Cancelled, (a_invest.Total_Paid - a_invest.Total_Cancelled) as Total_Amount_Invested
from a_invest
where date_invested >= '2021-01-01' AND date_invested <= '2021-12-31'
ORDER by 1;


--2.
-- Produce a query which gives the average successful portfolio per user split by country (where successful portfolio is the total amount of paid investment for each user)

SELECT distinct b.user_country as Country, AVG(a.amount_in_gbp) over (PARTITION by b.user_country) as Average_succesful_user_portfolio_in_GBP
from cc_investments a
join 
cc_investors b
on
a.user_id = b.user_id
where a.investment_status = 'paid';


--3.
--Write a query to find the number of users who made at least 2 investments January 2022

select user_id, count(*)
from dbo.cc_investments
where date_invested >= '2022-01-01'
	and date_invested <= '2022-01-31'
group by user_id
HAVING COUNT(*) >= 2



