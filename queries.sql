use walmart;
select * from walmart;
-- Q1. Find no. of transactions and qty sold for each payment method
select count(*) as no_of_payments , sum(quantity) as sum_qty from walmart group by payment_method;

-- Q2. Identify the highest rated category in each branch displaying the branch, category and avg rating
select branch,category,avg_rating from
    (select  branch,category,avg(rating) as avg_rating,
    rank() over(partition by branch order by avg(rating)DESC) as rank_rating from walmart 
    group by branch,category order by branch) x
    where rank_rating=1;

-- Q3. Identify the busiest day for each branch based on no. of transactions
select branch,day from(
select branch,dayName(str_to_date(`date`,'%d/%m/%y')) as day,count(*),
dense_rank()over(partition by branch order by count(*)) as rnk from walmart 
group by branch,day)x 
where x.rnk=1;

-- Q4 calculate the total qty of items sold per payment method. list payment method and total qty
select payment_method,sum(quantity) as total_qty from walmart
group by(payment_method);

-- Q5 determine avg rating , min and max rating for products for each city
select city,category, max(rating) as max_rating,min(rating) as min_rating,avg(rating) as avg_rating 
from walmart group by city,category order by city; 

-- Q6. calculate total profit for each category
select category, sum(total*profit_margin )as total_profit
from walmart group by category;  

-- Q7. Display the most common payment method for each branch
select branch,payment_method from
(select branch,payment_method, count(*) as count_payment_method ,
rank() over(partition by branch order by count(*) DESC) as rnk
from walmart group by branch , payment_method order by branch) x
where rnk=1;

-- Q8 categorize sales into 3 shifts based on time and calculate no of transactions
SELECT 
case 
   when Hour(STR_TO_DATE(`time`, '%H:%i:%s')) <12  then "Morning"
  when Hour(STR_TO_DATE(`time`, '%H:%i:%s')) between 12 and 17  then "Afternoon"
 else "Evening" 
 end  shift , 
 count(*) as No_Invoices from walmart
 group by shift;
 
 -- Q9. Identify 5 branch with highest decrease ratio in revenue compared to last year
 -- (current year 2023  and last year 2022
 
 
 
