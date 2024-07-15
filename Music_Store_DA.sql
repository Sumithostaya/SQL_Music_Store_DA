Create database srmusic ;

Use srmusic;

CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    title VARCHAR(50),
    reportsto INTEGER,
    level VARCHAR(10),
    birthdate DATETIME,
    hire_date DATETIME,
    address VARCHAR(120),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(30),
    postal_code VARCHAR(30),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(30)
);

CREATE TABLE customer(
customer_id integer PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
company VARCHAR(100),
address VARCHAR(100),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50),
postal_code VARCHAR(50),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(100),
support_rep_id int2);

CREATE TABLE invoice(
invoice_id integer PRIMARY KEY,
customer_id integer,
invoice_date datetime,
billing_address VARCHAR(120),
billing_city VARCHAR(30),
billing_state VARCHAR(30),
billing_country VARCHAR(30),
billing_postal VARCHAR(30),
total FLOAT8);


CREATE TABLE invoice_line(
invoice_line_id integer PRIMARY KEY,
invoice_id integer,
track_id integer,
unit_price float4,
quantity integer);

CREATE TABLE track(
track_id integer primary key ,
name varchar(200),
album_id integer,
media_type_id integer,
genre_id integer,
composer text,
milliseconds integer,
bytes integer,
unit_price float4);

CREATE TABLE playlist(
playlist_id integer PRIMARY KEY,
name  VARCHAR(30));

CREATE TABLE playlist_track(
playlist_id integer ,
track_id integer );

CREATE TABLE artist(
artist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30)); 

CREATE TABLE album(
album_id integer PRIMARY KEY,
title  VARCHAR(100),
artist_id  VARCHAR(100));

CREATE TABLE media_type(
media_type_id int2 PRIMARY KEY,
name VARCHAR(30)); 

CREATE TABLE genre(
genre_id integer PRIMARY KEY,
name VARCHAR(30));

load data local infile
"D:/Amit_Project/SQL_Music_Store_Analysis-main/music store data/employee.csv" -- use your file path
into table employee
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Show global variables like 'local_infile';
set global local_infile = 1;

Select * from track;

--  /*who is the senior most employee based on job title? */

select * from employee;

Select * 
from employee 
order by levels desc  
limit 1;

/*which country has the most invoices ? */

select * from invoice;

Select billing_country,
count(*) as bill_country_count
from invoice
group by billing_country
order by bill_country_count desc
limit 1;

/*What are the top 3 values of the total invoices?*/

Select * from invoice
order by total desc
limit 3;

/**//*Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money
Write a query that returns one city that has the highest sum of invoices totals.alter
Return both the city name and sum of all invoices totals*/

Select * from invoice;

Select billing_city, sum(total) as total_sum
from invoice 
group by billing_city
order by total_sum desc
limit 1;


-- /*Who is the best customer ? the customer who has spent the most money will be declared the best customer.alter.
-- Write the query that returns the person who has spent the most money.*/

select * from customer;
Select * from invoice;
Select i.customer_id, c.first_name, c.last_name, sum(i.total) as total_spent
from invoice i
inner join customer c
on i.customer_id=c.customer_id
group by 1
order by total_spent desc
limit 1;


/*Write query to return the email, first name, last name, & Genre of all Rock Music listeners,
 Return your list ordered alphabetically by email starting with A*/

 select distinct c.first_name, c.last_name, c.email
 from customer c
 join invoice i on c.customer_id=i.customer_id
 join invoice_line il on i.invoice_id=il.invoice_id
 where track_id in
 (select track_id from track t
 join genre g on t.genre_id=g.genre_id 
 where g.name='Rock'
 )
 order by c.email;


  /*Lets invite the artist who has written the most rock music in our dataset.
 Write query that return artist name and total track count of top 10 rock bands*/
 
  select a.artist_id, a.name, count(a.artist_id) as no_of_song
 from track t 
 Join album al on al.album_id=t.album_id
 join artist a on a.artist_id=al.artist_id
 join genre g on g.genre_id=t.genre_id
 where g.name like 'Rock'
 group by a.artist_id
 order by no_of_song desc
 limit 10;

 /* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT * FROM track;
Select name, Milliseconds
from track
where Milliseconds > avg(Milliseconds)
order by  Milliseconds desc;

/* Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4











 
 
 




