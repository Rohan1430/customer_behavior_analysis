use customer_behavior;
select customer_id, purchase_amount
from mytable
where discount_applied='Yes' and purchase_amount >=(select AVG(purchase_amount) from mytable);

select item_purchased, ROUND(AVG(CAST(review_rating AS DECIMAL(5,2))),2) as "Average Product Rating"
from mytable
group by item_purchased
order by avg(review_rating) desc
limit 5;

SELECT shipping_type,
ROUND(AVG(purchase_amount),2)
from mytable
where shipping_type in ('Standard','Express')
group by shipping_type;

select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from mytable
group by subscription_status
order by total_revenue, avg_spend desc;

select item_purchased,
ROUND(sum(case when discount_applied='Yes' then 1 else 0 end)/count(*) * 100,2) as discount_rate
from mytable
group by item_purchased
order by discount_rate desc
limit 5;

with customer_type as (
select customer_id, previous_purchases,
case 
when previous_purchases=1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from mytable
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;

with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from mytable
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank<=3;

select subscription_status,
count(customer_id) as repeat_buyers
from mytable
where previous_purchases > 5
group by subscription_status;

select age_group,
sum(purchase_amount) as total_revenue
from mytable
group by age_group
order by total_revenue desc;