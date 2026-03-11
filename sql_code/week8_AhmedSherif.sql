
CREATE Table cars(
selling_date DATE ,
seller_name TEXT,
seller_city TEXT,
seller_state TEXT,
seller_phone TEXT,
car_make TEXT,
car_model TEXT,
car_year INTEGER,
car_color TEXT,
customer_name TEXT,
customer_email TEXT,
customer_phone TEXT,
customer_address TEXT,
price NUMERIC
);


WITH sellers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY seller_name) AS seller_id, 
           seller_name, seller_city, seller_state, seller_phone
    FROM (SELECT DISTINCT seller_name, seller_city, seller_state, seller_phone FROM cars) AS s
),

cars_data AS (
    SELECT ROW_NUMBER() OVER (ORDER BY car_make, car_model) AS car_id, 
           car_make, car_model, car_year, car_color
    FROM (SELECT DISTINCT car_make, car_model, car_year, car_color FROM cars) AS c
),

customers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY customer_name) AS customer_id, 
           customer_name, customer_email, customer_phone, customer_address
    FROM (SELECT DISTINCT customer_name, customer_email, customer_phone, customer_address FROM cars) AS cust
),

orders AS (
    SELECT 
        ROW_NUMBER() OVER () AS order_id,
        c.selling_date,
        c.price,
        s.seller_id,
        cd.car_id,
        cust.customer_id
    FROM cars c
    JOIN sellers s ON s.seller_name = c.seller_name 
                  AND s.seller_phone = c.seller_phone
    JOIN cars_data cd ON cd.car_make = c.car_make 
                     AND cd.car_model = c.car_model 
                     AND cd.car_year = c.car_year 
                     AND cd.car_color = c.car_color
    JOIN customers cust ON cust.customer_name = c.customer_name 
                       AND cust.customer_phone = c.customer_phone
)
SELECT * FROM orders;
