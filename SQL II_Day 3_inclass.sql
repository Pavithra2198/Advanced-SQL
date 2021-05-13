# Datasets used: AirlineDetails.csv, passengers.csv and senior_citizen.csv
-- -----------------------------------------------------
-- Schema Airlines
-- -----------------------------------------------------
create database airlines;
use airlines;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create a table Airline_Details. Follow the instructions given below: 
-- -- Q1. Values in the columns Flight_ID should not be null.
-- -- Q2. Each name of the airline should be unique.
-- -- Q3. No country other than United Kingdom, USA, India, Canada and Singapore should be accepted
-- -- Q4. Assign primary key to Flight_ID

create table airline_details(
flight_id int not null,
p_name varchar(25) unique,
country varchar(20) check(country in ('United kingdom','USA','India','Canada','Singapore')),
constraint airline_details_pk primary key(flight_id)
);
desc airline_details;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Create a table Passengers. Follow the instructions given below: 
-- -- Q1. Values in the columns Traveller_ID and PNR should not be null.
-- -- Q2. Only passengers having age greater than 18 are allowed.
-- -- Q3. Assign primary key to Traveller_ID
create table passenger(
traveller_id int not null,
pnr int not null,
age int check(age>18),
constraint passenger_pk primary key(traveller_id)
);
desc passenger;
alter table passenger add column flight_id int not null after traveller_id;

-- Questions for table Passengers:  
-- -- Q3. PNR status should be unique and should not be null.
-- -- Q4. Flight Id should not be null.

alter table passenger modify pnr varchar(10) not null unique;
desc passenger;
alter table passenger modify flight_id int not null;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Create a table Senior_Citizen_Details. Follow the instructions given below: 
-- -- Q1. Column Traveller_ID should not contain any null value.
-- -- Q2. Assign primary key to Traveller_ID
-- -- Q3. Assign foreign key constraint on Traveller_ID such that if any row from passenger table is updated, then the Senior_Citizen_Details table should also get updated.
-- -- --  Also deletion of any row from passenger table should not be allowed.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
create table senior_Citizen_Detail(
traveller_id varchar(5) not null,
senior_citizen varchar(5) null,
discounted_price varchar(20) null,
primary key(traveller_id),
constraint citizen_fk foreign key(traveller_id) references passenger(traveller_id) on update cascade
on delete restrict
);

-- -----------------------------------------------------
-- Table Senior_Citizen_Details
-- -- Q6. Create a new column Age in Passengers table that takes values greater than 18. 
 alter table passenger add age int check(age>18) ;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Create a table books. Follow the instructions given below: 
-- -- Columns: books_no, description, author_name, cost
-- -- Qa. The cost should not be less than or equal to 0.
-- -- Qb. The cost column should not be null.
-- -- Qc. Assign a primary key to the column books_no.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
create table book(
book_no int primary key,
description text,
author_name varchar(200),
cost decimal(10,2) not null check (cost>0)
);

# Q8. Update the table 'books' such that the values in the columns 'description' and author' must be unique.

alter table book add constraint new_desc1 unique (description,author);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Create a table bike_sales. Follow the instructions given below: 
-- -- Columns: id, product, quantity, release_year, release_month
-- -- Q1. Assign a primary key to ID. Also the id should auto increment.
-- -- Q2. None of the columns should be left null.
-- -- Q3. The release_month should be between 1 and 12 (including the boundries i.e. 1 and 12).
-- -- Q4. The release_year should be between 2000 and 2010.
-- -- Q5. The quantity should be greater than 0.
-- --------------------------------------------------------------------------
-- Use the following comands to insert the values in the table bike_sales
/*('1','Pulsar','1','2001','7');
('2','yamaha','3','2002','3');
('3','Splender','2','2004','5');
('4','KTM','2','2003','1');
('5','Hero','1','2005','9');
('6','Royal Enfield','2','2001','3');
('7','Bullet','1','2005','7');
('8','Revolt RV400','2','2010','7');
('9','Jawa 42','1','2011','5');*/
-- --------------------------------------------------------------------------
select * from airlinedetails;
create table bike_sale(
id int auto_increment primary key,
product varchar(100) not null,
quantity int not null,
release_year int not null,
release_month int not null,
check(release_month>=1 and release_month<=12),
check(release_year between 2000 and 2010),
check(quantity>0)
);
INSERT INTO bike_sales VALUES('1','Pulsar','1','2001','7');
INSERT INTO bike_sales VALUES('2','yamaha','3','2002','3');
INSERT INTO bike_sales VALUES('3','Splender','2','2004','5');
INSERT INTO bike_sales VALUES('4','KTM','2','2003','1');
INSERT INTO bike_sales VALUES('5','Hero','1','2005','9');
INSERT INTO bike_sales VALUES('6','Royal Enfield','2','2001','3');
INSERT INTO bike_sales VALUES('7','Bullet','1','2005','7');
INSERT INTO bike_sales VALUES('8','Revolt RV400','2','2010','7');
INSERT INTO bike_sales VALUES('9','Jawa 42','1','2010','5');
-- --------------------------------------------------------------------------
SELECT * FROM BIKE_SALES;
insert into bike_sales(product, quantity, release_year, release_month) 
values ('Honda', '5', '2005','6');