Select * from credits
select * from titles

-- Filling null values with 'unknown' using coalesce() function

select 
coalesce(age_certification, 'Unknown') as age_certification
from titles;

update titles
set age_certification= coalesce(age_certification,'Unknown');

update titles
set age_certification= 'Unknown'
where age_certification is null or LTRIM(rtrim(age_certification))='';

select * from titles
where age_certification is  null;

-------- making first letters capital in genres column 

update titles
set genres = UPPER(left(genres,1))+ LOWER(substring(genres,2,len(genres)))


---- name, character, type and title by year 

select credits.name, credits.character, titles.type, titles.release_year
from credits
join titles
on credits.id=titles.id;

----- to display oly two decimal places for the tmdb_popularity column
select 
    ROUND(titles.tmdb_popularity,2) as tmdb_popularity
	from titles;

	update titles
	set tmdb_popularity= ROUND(tmdb_popularity,2);

----- movie released after 2010 with IMDB score

select titles.title,titles.type, titles.release_year, titles.imdb_score
from titles 
where titles.type ='MOVIE' and titles.release_year > 2010
group by titles.title,titles.type, titles.release_year, titles.imdb_score
order by release_year asc ;

----- total runtime of movies
select  titles.type, sum( titles.runtime) as 'total movies run time',
round(avg(titles.runtime),2) as 'avg movies run time' 
from titles
where titles.type= 'MOVIE'
group by  titles.type;

------ total runtime of shows and to display only 2 decimals in avg 
select  titles.type, sum( titles.runtime) as 'total Shows run time',
round(avg(titles.runtime),2) as 'avg Shows run time'
from titles
where titles.type= 'SHOW'
group by  titles.type;

------- no of seasons in each show by title and  year with actor 
select titles.title, titles.type, titles.release_year , titles.seasons,
credits.name as 'actor name', credits.character
from titles
join credits
on titles.id=credits.id
where titles.type= 'SHOW';

