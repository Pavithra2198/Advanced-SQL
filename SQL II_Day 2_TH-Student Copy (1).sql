CREATE SCHEMA IF NOT EXISTS Video_Games;
USE Video_Games;
SELECT * FROM Video_Games_Sales;

# 1. Display the names of the Games, platform and total sales in North America for respective platforms.

select Name,Platform,sum(NA_Sales) over(partition by Platform) as total_sales from Video_Games_Sales;

# 2. Display the name of the game, platform , Genre and total sales in North America for corresponding Genre as Genre_Sales,total sales for the given platform as Platformm_Sales and also display the global sales as total sales .
# Also arrange the results in descending order according to the Total Sales.

select Name,Platform,Genre, sum(NA_sales) over(partition by Genre) as Genre_Sales,sum(NA_Sales) over(partition by Platform) as Platform_Sales,
sum(Global_Sales) over() as total_sales from video_games_sales order by total_sales desc;

# 3. Use nonaggregate window functions to produce the row number for each row 
# within its partition (Platform) ordered by release year.

select Platform,year_of_release,row_number() over(partition by Platform order by year_of_release) as rownum
from video_games_sales;

# 4. Use aggregate window functions to produce the average global sales of each row within its partition (Year of release). Also arrange the result in the descending order by year of release.
   
select year_of_release,avg(Global_Sales) over(Partition by year_of_release)
from video_games_sales order by year_of_release desc;


# 5. Display the name of the top 5 Games with highest Critic Score For Each Publisher. 

select * from 
(select publisher,name,dense_rank() over(partition by publisher order by critic_score desc)
as rnk from video_games_sales)t where rnk between 1 and 5;
------------------------------------------------------------------------------------
# Dataset Used: website_stats.csv and web.csv
------------------------------------------------------------------------------------
# 6. Write a query that displays the opening date two rows forward i.e.
# the 1st row should display the 3rd website launch date

select * from website_stats;
select * from web;
select *,lead(launch_date,2) over() as forward_launch_date from web;

# 7. Write a query that displays the statistics for website_id = 1 i.e.
# for each row, show the day, the income and the income on the first day.

select day,income,first_value(income) over(order by day) as firstday_income
from website_stats where website_id=1;
-----------------------------------------------------------------
# Dataset Used: play_store.csv 
-----------------------------------------------------------------
# 8. For each game, show its name, genre and date of release. In the next three columns,
# show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.

select name,genre,released,rank() over(order by released) as 'rank',
dense_rank() over(order by released) as 'dense rank', row_number() over(order by released) as 'row number'
from play_store;
