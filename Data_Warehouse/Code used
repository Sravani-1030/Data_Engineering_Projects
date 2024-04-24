CREATE table datedim (
	date_key integer NOT NULL Primary key,
	date date NOT NULL,
	year smallint NOT NULL,
	quarter smallint NOT NULL,
	month smallint NOT NULL,
	week smallint NOT NULL,
	day smallint NOT NULL,
	is_weekend smallint NOT NULL
);


CREATE table moviedim(
	movie_key integer primary key,
	film_id smallint NOT NULL,
	title varchar NOT NULL,
	description varchar NOT NULL,
	release_year smallint NOT NULL,
	language varchar NOT NULL,
	length smallint NOT NULL,
	rating varchar NOT NULL,
	special_features varchar NOT NULL
);

CREATE TABLE customersdim(
	customer_key serial PRIMARY KEY,
	customer_id smallint NOT NULL,
	first_name varchar not null,
	last_name varchar not null,
	email varchar not null,
	phone varchar not null,
	address varchar not null,
	address2 varchar not null,
	district varchar not null,
	city varchar not null,
	country varchar not null,
	postal_code varchar not null,
	active smallint not null,
	create_date TIMESTAMP not null,
	start_date date not null,
	end_date date not null
);

CREATE TABLE storedim(
	store_key serial primary key,
	manager_first_name varchar not null,
	manager_last_name varchar not null,
	address varchar not null,
	address2 varchar,
	district varchar not null,
	city varchar not null,
	country varchar not null,
	postal_code varchar not null,
	start_date date not null,
	end_date date not null
);


create table salesfact(
 	sales_key serial primary key,
 	date_key integer references datedim(date_key),
 	customer_key integer references customersdim(customer_key),
 	movie_key integer references moviedim(movie_key),
 	store_key integer references storedim(store_key),
 	sales_amount numeric
 	);

INSERT INTO datedim(date_key,date, year,quarter,month, week,day,is_weekend)
select
	distinct (to_char (payment_date :: Date, 'yyMMDD') :: integer) as date_key,
	date (payment_date) as date,
	extract (year from payment_date) as year,
	extract (quarter from payment_date) as quarter,
	extract (month from payment_date) as month,
	extract (week from payment_date) as week,
	extract (day from payment_date) as day,
	case when extract(isodow from payment_date) IN (6,7) THEN True else False end
from payment;


Select * from datedim;





INSERT INTO customersdim(customer_key,customer_id,first_name,last_name,email,phone,district,city,country,postal_code,active,create_date,start_date,end_date)
select  customer.customer_id as customer_key,
		customer.customer_id,
		customer.first_name,
		customer.last_name,
		customer.email,
		address.phone,
		city.city,
		country.country,
		address.district,
		address.postal_code,
		customer.active,
		customer.create_date,
		now() as start_date,
		now() as end_date
from customer
join address on address.address_id = customer.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;


select * from customersdim;


INSERT INTO moviedim(movie_key,film_id,title,description,release_year,language,rating,special_features,length)
select film.film_id as movie_key,
		film.film_id,
		film.title,
		film.description,
		film.release_year,
		language.name as language,
		film.rating,
		film.special_features,
		film.length
from film 
join language on film.language_id = language.language_id;


select * from information_schema.columns where table_name = 'moviedim';

select * from moviedim;



insert into salesfact(date_key,customer_key,movie_key,store_key,sales_amount)
select
	
	to_char(payment_date:: DATE, 'YYMMDD') :: integer As date_key,
	p.customer_id as customer_key,
	i.film_id as movie_key,
	i.store_id as store_key,
	p.amount as sales_amount
	from payment p
	join rental r on r.rental_id = p.rental_id
	join inventory i on r.inventory_id = i.inventory_id;


select moviedim.title, datedim.month, customersdim.city, sum(sales_amount) as revenue 
from salesfact
join moviedim on salesfact.movie_key = moviedim.movie_key
join datedim on datedim.date_key = salesfact.date_key
join customersdim on customersdim.customer_key = salesfact.customer_key
group by  moviedim.title, datedim.month, customersdim.city
order by moviedim.title, datedim.month, customersdim.city, revenue desc



------------Without Using DataWarehouse---------------------------------------
select f.title, extract(month from p.payment_date) as month, ci.city, sum(p.amount) as revenue
from payment p
join rental r on p.rental_id =r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on c.customer_id = p.customer_id
join address a on a.address_id= c.customer_id
join city ci on ci.city_id = a.city_id
group by f.title, month, ci.city
order by f.title, month, ci.city, revenue desc


