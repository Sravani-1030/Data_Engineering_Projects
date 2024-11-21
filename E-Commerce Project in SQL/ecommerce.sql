create table ecommerce(
row_number int,
orderid int,
product_category varchar(25),
product varchar(50),
quantity_ordered int,
price_each numeric,
order_date varchar,
purchased_address varchar,
month int,
sales numeric,
city varchar(20),
hour int,
time_of_day varchar(20)
)

drop table ecommerce;

select * from ecommerce

select orderid, count(purchased_address)
from ecommerce
group by orderid
having count(purchased_address) >=5

-----------------finding the names of the columns-------------------
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND 
table_name = 'ecommerce';

-----------------changing the order date to have same format-----------
UPDATE ecommerce
SET order_date = TO_TIMESTAMP(order_date, 'DD-MM-YYYY HH24:MI')::TEXT



select * from ecommerce
---------------first question--------------------------------------
select purchased_address, max(order_date) as recent_purchase_date, count(order_date) as frequency, sum(sales) as money_spent
from ecommerce
group by purchased_address
order by frequency desc
-------------------2nd question------------------------------------
-------------------grouping the orders -----------
SELECT purchased_address, orderid, ARRAY_AGG(product) AS basket
FROM ecommerce
GROUP BY purchased_address, orderid;

----------making the array to rows and dividing them as combinations------------
WITH expanded AS (
    SELECT purchased_address, orderid, UNNEST(basket) AS product
    FROM (
        SELECT purchased_address, orderid, ARRAY_AGG(product) AS basket
        FROM ecommerce
        GROUP BY purchased_address, orderid
    ) subquery
), 

--------------------forming the combinations---------------
expanded_pairs AS (
    SELECT e1.purchased_address, e1.product AS product_1, e2.product AS product_2
    FROM expanded e1
    JOIN expanded e2 
      ON e1.purchased_address = e2.purchased_address
      AND e1.orderid = e2.orderid
      AND e1.product < e2.product
)

-----------------finding the count of the combinations that are mostly bought------------------
SELECT product_1, product_2, COUNT(*) AS frequency
FROM expanded_pairs
GROUP BY product_1, product_2
ORDER BY frequency DESC;





--------------------------------------items frequently bought by same customers----------------
WITH baskets AS (
        SELECT purchased_address, orderid, ARRAY_AGG(product) AS basket
        FROM ecommerce
        GROUP BY purchased_address, orderid
    )

SELECT purchased_address, basket, COUNT(*) AS frequency
FROM baskets
GROUP BY purchased_address, basket
HAVING COUNT(*) > 1 -- Only show combinations bought more than once
ORDER BY frequency DESC;
