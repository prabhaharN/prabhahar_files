WITH fib_series (num1, num2,num3) AS (
    SELECT 1, 0,1 FROM dual
    UNION all
    SELECT num1 + 1, num3,num3+num2 FROM fib_series
    where num1<10
)
SELECT * FROM fib_series;


with number1 (num1,letter) as 
(select 1 as num1,'1' as letter from dual 
union all 
select num1+1,rpad(to_char(num1),num1,to_char(num1))
from number1 where num1<=4)
select distinct letter from number1
order by letter;

select lpad('d', 3,'d') from dual;


select rpad(to_char(level),level,to_char(level)) from dual
connect by level<5;


with number1 (num1,num2,letter) as 
(select 1 as num1,5 as num2 ,'0' as letter from dual 
union all 
select num1+1,num2-1,lpad(' ',num2,' ')||rpad(to_char(num1),num1,to_char(num1)) as letter
from number1 where num1<=5)
select letter from number1 offset 1 rows;

-- each team play with other team one time
select t.*,o.* from teams_d t join teams_d o on t.team_id < o.team_id;
-- each team play with other team twice
select t.*,o.* from teams_d t join teams_d o on t.team_id <> o.team_id;


select generate_series(1,10) from dual;


select number1, rn from (select n.number1,row_number()over(partition by number1 order by number1) as rn
from number_1 n 
connect by level<n.number1
order by number1) where rn<=number1;


insert into number_1 values(4);
select w.* ,row_number()over(order by null) rn from number_1 w ;




select * from employee;

select trunc(sysdate,'Q') from dual ;
select trunc(sysdate,'w') from dual ;
select trunc(sysdate,'dd') from dual ;
select trunc(sysdate,'month') from dual ;
select trunc(sysdate,'Y') from dual ;



select * from number_1;

with cte as ( select number1,1 as number2 from number_1 
union all
select number1,number2+1 as number2 from cte c where number2<=number1)

select * from cte;


WITH cte (number1,number2)AS (
    SELECT distinct number1, 1 AS number2
    FROM number_1
    UNION ALL
    SELECT number1, number2 + 1 AS number2
    FROM cte
    WHERE number2 < number1
)
SELECT * 
FROM cte
order by number1,number2;



with cte as(SELECT distinct column_name 
FROM all_tab_columns
where table_name='DPT'),

--select * from cte

cte2 as (select listagg(column_name,', ') as col1 from cte)

--select * from cte2

select e.* ,count(*) from dpt e
group by (select col1 from cte2);
 
 




select n.*,count(*) from number_1 n group by (SELECT column_name
FROM all_tab_columns
WHERE table_name = 'number1');


desc number_1;


select * from dpt;


select number1,max(number1) from number_1
group by number1
order by 1 desc,2 asc;


select * from number_1 where mod(number1,2)<>0;

select * from employee
order by emp_sal desc;

SELECT * 
FROM employee t2 
WHERE 1 = (
    SELECT COUNT(DISTINCT emp_sal) 
    FROM employee t 
    WHERE t.dept_id=t2.dept_id and t.emp_sal > t2.emp_sal
);


select extract (second from (systimestamp+ interval '300' second) -(systimestamp) )as difference from dual;


select sysdate ,sysdate + interval '-3' day  from dual;


--Scenario: You have a table called "orders" with columns "order_id", "customer_id", "order_date", and 
--"total_amount". Write a query to find the customers who have placed an order in the last 30 days, but not in the last 14 days.

select distinct customer_id from orders where order_date between(sysdate-30) and (sysdate-14);



--Scenario: You have a table called "products" with columns "product_id", "product_name", "price", 
--and "product_category". Write a query to find the products that have a price greater 
--than the average price of all products in their category, but less than the maximum price in their category.

select product_name from products p 
where price >(select avg(price) from products p1 where p1.category=p.category) 
and price <( select max(price) from products p1 where p1.category=p.category);



--website_traffic -- date,page_views,unique_visitors

select e.date
from website_trffic e inner join web_traffic e1 on e.date = e1.date-1
where ((e.page_views-e1.page_views)/e.page_views)*100>=20 and ((e.unique_users-e1.unique_user)/e.unique_user)*100>=15
order by e.date
;

--orders-- order_id,customer_id,order_date,total_amount. exactly 3 orders in last 90 days and total amount >500

select customer_id from orders where order_date > sysdate-90 group by customer_id having count(order_id)=3 and sum(total_amount)>500;




select emp_id,emp_name,dept_id,emp_sal,sum(emp_sal) over(order by emp_id) as run_tot , sum(emp_sal) over() as tot_sal
,sum(emp_sal) over(partition by dept_id order by emp_id ) as dept_run_sal,sum(emp_sal) over(partition by dept_id) as dept_sal
from employee e
order by emp_id