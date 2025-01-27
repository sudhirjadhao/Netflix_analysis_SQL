--- Netflix Project

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts  VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	desciption VARCHAR(250)
);

Select * from netflix;


select count (*) as total_content 
       from netflix;

select Distinct type 
       from netflix;


---- 15 Business problem------

--1. Count the number of Movies vs TV shows
Select
   type,
   count(*) as total_content
from netflix
Group by type

--2. Find the most common rating from movies and TV shows

select type,
       rating
from

(select type,
       rating,
	   count(*),
	   rank() over(partition by type order by count(*) DESC) as ranking
from netflix
group by 1,2) as t1
where ranking =1


--3. list all movies released in a specific year (e.g., 2020)

select * 
from netflix
where release_year=2020 and
      type= 'Movie';


--4. Find the top 5 countries with the most content on netflix
select 
       unnest(string_to_array(country,',')) as new_country,
	   count(show_id) as total_content
from netflix
group by country
order by total_content desc
limit 5;

--5. Identify the longest movie

select title
from netflix
where type='Movie' and duration= (select max(duration) from netflix)


--6 Find content added in the last 5 years

select *
from netflix
where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';


--7. Find all the movies/TV shows by director Rajiv Chilaka

select * 
from netflix
where director Ilike '%Rajiv Chilaka%';

--8. List all tv shows with more than 5 seasons
select *
from netflix
where type ='TV Show' and SPLIT_PART(duration, ' ',1)::numeric > 5 ;


--9. count the number of content items in each genre

select unnest(string_to_array(listed_in, ',')) as genre,
       count(show_id) as total_content
from netflix
group by genre;

--10. Find each year and the average number of content released by
--india on netflix, return top 5 year with highest avg cotent release

Select 
extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
count(*) as yearly_content,
round(
count(*)::numeric/(select count(*) from netflix where country= 'India')::numeric * 100, 2)
as avg_content_per_year
from netflix
where country ='India'
group by year;

--11. list all movies that are documentaries
select *
from netflix
where listed_in Ilike '%documentaries%';


--12. find all content withour dierector

select *
from netflix
where director is null;

--13.find how many movies actor 'salman khan' appeared in last 10 years.

select * 
from netflix
where casts Ilike '%salman khan%' and release_year > extract( year from current_date) - 10 ;


--14. Find the top 10 actor who have appeared in the highest number of movies produced in India
select unnest(string_to_array(casts, ',')) as actors,
count (*) as total_content
from netflix
where country  ilike '%india%'
group by actors
order by total_content desc
limit 10;

--15. categorise the content based on the presence of the keywords 'kill' and 'violence' in the description field.
 label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into
 each category

with new_table as (
select *, 
    case
    when desciption ilike '%kill%' or
	desciption ilike '%violence%' then 'BadContent'
	else 'Good content'
	end category
from netflix )

select category,
       count (*) as total_content
from new_table
group by category;








	
