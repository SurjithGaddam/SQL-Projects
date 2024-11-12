Create Database IPL;
Select * from ipl_ball_by_ball_2008_2022;
select * from ipl_matches_2008_2022;

--- Strike Rate by each team per season 
Create Proc spgetstrike_rate_per_team
@Season nvarchar(200)
as
begin
Select Season,batting_team,sum(batsman_run) as 'Total Runs',COUNT(*) as 'Total balls',
Format((SUM(batsman_run)*100.0 /COUNT(*)),'N2')+'%' as Stirke_rate
from ipl_matches_2008_2022
join ipl_ball_by_ball_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
Where season in(Select * from string_split(@Season,','))
group by season,batting_team
Order by batting_team ASC
End;

exec spgetstrike_rate_per_team @Season = 2009;

-----  toss winner and toss decision
select Season,toss_winner,COUNT(*) as 'No of Toss won', toss_decision
from ipl_matches_2008_2022
where toss_decision= 'bat' 
group by Season,toss_winner,toss_decision;

select Season,toss_winner,COUNT(*) as 'No of toss won', toss_decision
from ipl_matches_2008_2022
where toss_decision= 'field'
group by Season,toss_winner,toss_decision;


----- Matches win by result type using stored procedure 
Create proc spget_matches_wins_by_resulttype
@won_by nvarchar(200), @Season nvarchar(200) 
as
begin 
Select Season,COUNT(*) as total, won_by b
from ipl_matches_2008_2022
where  won_by in(Select * from string_split(@won_by,',')) and season in(select * from string_split(@Season,','))
group by season, won_by
end;

Exec spget_matches_wins_by_resulttype @won_by='Wickets,Runs,No Results' , @Season ='2008,2009,2010';


------ total wins by team per season
Select season, winning_team,COUNT(*) as 'total wins'
from ipl_matches_2008_2022
group by season, winning_team;

---- Matches win by venue each season
select season,city, venue,COUNT(*) as total_Matches,won_by
from ipl_matches_2008_2022
group by season,city,venue,won_by;

---------- total sixes per season
Select Season,COUNT(*) as 'total Sixes' 
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
Where batsman_run=6
group by Season,batsman_run
order by season, batsman_run;

---Total fours per season

Select Season,COUNT(*) as 'total Fours' 
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
Where batsman_run=4
group by Season,batsman_run
order by Season,batsman_run;

--- Total wickets per season 
Select Season,COUNT(*) as 'Total Wickets' 
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
Where iswicket_delivery=1
group by Season,iswicket_delivery
order by Season,iswicket_delivery;

---- Batsman runs per season
Select  Season,batter,SUM(batsman_run) as total_runs
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
group by season,batter
order by season, total_runs desc;


---orange cap per season

WITH RankedBatsmen AS (
    SELECT season, batter, SUM(batsman_run) AS total_runs,
    ROW_NUMBER() OVER (PARTITION BY season ORDER BY SUM(batsman_run) DESC) AS rank
    FROM ipl_ball_by_ball_2008_2022
    JOIN ipl_matches_2008_2022 
    ON ipl_ball_by_ball_2008_2022.id = ipl_matches_2008_2022.id
    GROUP BY season,batter
)
SELECT season,batter,total_runs
FROM RankedBatsmen
WHERE rank = 1
ORDER BY season;

----- Bowlers wickets per season

Select  Season,bowler,count(iswicket_delivery) as total_wickets
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
where iswicket_delivery=1
group by season,bowler
order by season, total_wickets desc;

-------- Purple cap per season
WITH RankedBowler AS (
    SELECT season, bowler, count(iswicket_delivery) AS total_wickets,
    ROW_NUMBER() OVER (PARTITION BY season ORDER BY count(iswicket_delivery) DESC) AS rank
    FROM ipl_ball_by_ball_2008_2022
    JOIN ipl_matches_2008_2022 
    ON ipl_ball_by_ball_2008_2022.id = ipl_matches_2008_2022.id
	where iswicket_delivery=1
    GROUP BY season,bowler
)
SELECT season,bowler,total_wickets
FROM RankedBowler
WHERE rank = 1
ORDER BY season;

----- title winner per season
Select Season,winning_team,COUNT(*) as 'Title Winner'
from ipl_matches_2008_2022
Where match_number='Final'
group by Season,winning_team
Order by season ASC;

-------- total extras by team per season
Select Season, sum(extras_run) as 'Total Extras',extra_type
from ipl_ball_by_ball_2008_2022
join ipl_matches_2008_2022
on ipl_ball_by_ball_2008_2022.id=ipl_matches_2008_2022.id
where extra_type != 'NA'
group by season,extra_type
order by season;


