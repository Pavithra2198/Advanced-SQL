use ds;

-- --------------------------------------------------------------
# Dataset Used: wine.csv
-- --------------------------------------------------------------

SELECT * FROM wine;

# Q1. Rank the winery according to the quality of the wine (points).-- Should use dense rank
select winery,points,dense_rank() over(order by points) from wine;

# Q2. Give a dense rank to the wine varities on the basis of the price.
select country,points,designation,variety,price,dense_rank() over(partition by variety order by price)
as rank_byprice from wine ;

# Q3. Use aggregate window functions to find the average of points for each row within its partition (country). 
-- -- Also arrange the result in the descending order by country.
select *,avg(points) over(partition by country ) from wine order by country desc;
-----------------------------------------------------------------
# Dataset Used: students.csv
-- --------------------------------------------------------------

# Q4. Rank the students on the basis of their marks subjectwise.
select * from students;
select student_id,subject,marks,rank() over(partition by subject order by marks desc ) rankk from students;

# Q5. Provide the new roll numbers to the students on the basis of their names alphabetically.
select *,row_number() over(order by name ) as new_roll_number from students;

# Q6. Use the aggregate window functions to display the sum of marks in each row within its partition (Subject).
select *,sum(marks) over(partition by subject) totalmarks from students;

# Q7. Display the records from the students table where partition should be done 
-- on subjects and use sum as a window function on marks, 
-- -- arrange the rows in unbounded preceding manner.
select *,
sum(marks) over(partition by subject rows unbounded preceding) as std_records
from students;

# Q8. Find the dense rank of the students on the basis of their marks subjectwise. Store the result in a new table 'Students_Ranked'

create table students_ranked as
select subject, marks, dense_rank() over(partition by subject order by marks desc) from students;

desc students_ranked;
select * from students_ranked;
-----------------------------------------------------------------
# Dataset Used: website_stats.csv and web.csv
-----------------------------------------------------------------
# Q9. Show day, number of users and the number of users the next day (for all days when the website was used)
select * from website_stats;
-- update website_stats set day=str_to_date(day,'%d-%m-%y');
select day,no_users,(total-no_users) next_day from
(select day,no_users,sum(no_users) over(rows between current row and 1 following) total from website_stats)a;
-- (or)
select day,no_users,lead(no_users,1) over (order by day) from website_stats;

# Q10. Display the difference in ad_clicks between the current day and the next day for the website 'Olympus'

Select day,no_users,ad_clicks,(ad_clicks-lead(ad_clicks,1) over (order by day)) diff from website_stats
where website_id =(select id from web where name = 'Olympus')  ;
-- (or)
select ws.website_id,w.name,ws.day,(ws.ad_clicks)-(lead(ws.ad_clicks,1)
over (partition by w.name order by ws.day)) as next_day from website_stats ws join web w
on ws.website_id=w.id where w.name like '%olympus%';

# Q11. Write a query that displays the statistics for website_id = 3 such that for each row, show the day, 
# the number of users and the smallest number of users ever.
select * from web;
select *,min(no_users) over() as smallest_user from website_stats where website_id=3 group by no_users;
-- (or)
select website_id,day,no_users,first_value(no_users) over(order by no_users) as small_users_ever
from website_stats where website_id = 3 order by day;

# Q12. Write a query that displays name of the website and it's launch date.
# The query should also display the date of recently launched website in the third column.

select name,launch_date,first_value(launch_date) 
over(order by str_to_date(launch_date,'%d-%m-%y')desc) as recent_launch_date
from web;

-----------------------------------------------------------------
# Dataset Used: play_store.csv and sale.csv
-----------------------------------------------------------------
# Q13. Write a query thats orders games in the play store into three buckets as per editor ratings received  
select * from sale;
select *,ntile(3) over(order by editor_rating) as bucket_no from 
play_store;

# Q14. Write a query that displays the name of the game, the price, the sale date and the 4th column should display 
# the sales consecutive number i.e. ranking of game as per the sale took place,
# so that the latest game sold gets number 1. Order the result by editor's rating of the game

select name,price,date as sale_date,rank() over (order by str_to_date(date,'%d-%m-%y')desc) as date_rank
from play_Store as ps join sale as s on ps.id=s.game_id order by editor_rating;

# Q15. Write a query to display games which were both recently released and recently updated. For each game, show name, 
#date of release and last update date, as well as their rank
#Hint: use ROW_NUMBER(), sort by release date and then by update date, both in the descending order

 select *,row_number() over (order by released desc,updated desc) as 'Rank' from play_store;
-----------------------------------------------------------------
# Dataset Used: movies.csv, customers.csv, ratings.csv, rent.csv
-----------------------------------------------------------------
# Q16. Write a query that displays basic movie informations as well as the previous rating provided by customer for that same movie 
# make sure that the list is sorted by the id of the reviews.
select * from movies;
select * from ratings;
select concat(first_name,' ',last_name)as customer_name,title,release_year,genre,editor_rating,
rating as customer_rating,lag(rating,1,'no previous customer rating') 
over(partition by title order by r.id)previous_customer_rating from ratings r
join movies m on r.movie_id=m.id join customers_1 c on c.id=r.customer_id order by r.id;

# Q17. For each movie, show the following information: title, genre, average user rating for that movie 
# and its rank in the respective genre based on that average rating in descending order
# (so that the best movies will be shown first).
with subquery(average,mid) as (select avg(rating),movie_id from ratings group by movie_id)
select title,genre,average,rank() over(partition by genre order by average desc) from movies,subquery;

# Q18. For each rental date, show the rental_date, the sum of payment amounts (column name payment_amounts) from rent 
#on that day, the sum of payment_amounts on the previous day and the difference between these two values.
select * from rent;
with subquery(pay,rdate) as (select sum(payment_amount),rental_date from rent group by str_to_date(rental_date,'%y-%m-%d'))
select rental_date,pay,lag(pay,1,0) over(order by str_to_date(rental_date,'%y-%m-%d')) as pre_pay, pay-lag(pay,1,0) over(order by str_to_date(rental_date,'%y-%m-%d')) as diff
from rent,subquery where rent.rental_date=subquery.rdate;
