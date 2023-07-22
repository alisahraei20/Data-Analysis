                                       -- Analysis utilizing Subqueries and CTE

USE AdventureWorks2019;

-- Subqueries

select
a.ordermonth,
a.top10total,
PrevToptentotal = b.top10total
from
(select
ordermonth, 
top10total =sum(TotalDue)
from(
SELECT 
orderdate,
totaldue,
ordermonth=datefromparts(year(orderdate),month(orderdate),1),
orderrank = ROW_NUMBER() over(partition by datefromparts(year(orderdate),month(orderdate),1) order by totaldue desc)

from sales.SalesOrderHeader) x

where orderrank <=10
group by ordermonth) A

left join
(select
ordermonth, 
top10total =sum(TotalDue)
from(
SELECT 
orderdate,
totaldue,
ordermonth=datefromparts(year(orderdate),month(orderdate),1),
orderrank = ROW_NUMBER() over(partition by datefromparts(year(orderdate),month(orderdate),1) order by totaldue desc)

from sales.SalesOrderHeader) x

where orderrank <=10
group by ordermonth) B on a.ordermonth = dateadd(month,1,B.ordermonth)
order by 1;

-- CTE

with sales as

(SELECT 
orderdate,
totaldue,
ordermonth=datefromparts(year(orderdate),month(orderdate),1),
orderrank = ROW_NUMBER() over(partition by datefromparts(year(orderdate),month(orderdate),1) order by totaldue desc)

from sales.SalesOrderHeader),
top10 as (
select
ordermonth, 
top10total =sum(TotalDue)
from
sales
where orderrank <=10
group by ordermonth
)

select
a.ordermonth,
a.top10total,
PrevToptentotal = b.top10total
from top10 a left join top10 b on a.ordermonth = dateadd(month,1,B.ordermonth)

order by 1;
