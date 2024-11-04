----Skills Used : CTE, Aggregrate function, Union function, group by , joins, Store procedures, views
create database bigbash_league;
select * from [BBL_Matches 2011-2019];
select * from BBL_Ball_by_ball;

------- total matches and  team with most wins between 2011-2019 and wins %
with Team_Matches as (
 select 
 team as team,
 COUNT(*) as total_matches 
 from (
   select team1 as team from [BBL_Matches 2011-2019]
   union all 
   select team2 as team from [BBL_Matches 2011-2019]
   ) as Teams
   group by team
   )

 select 
 winner as team,
 count(*) as Total_wins,
 tm.total_matches,
FORMAT(count(*) * 100.0/ tm.total_matches, 'N2')+'%' as winning_percentage
 from
 [BBL_Matches 2011-2019] as bbl
 join Team_Matches as tm on bbl.winner = tm.team
 group by winner, tm.total_matches 
 order by 
 Total_wins desc;

------- Total Sixes and Fours by team in all teh matches 
with Team_Matches as (
 select 
 team as team,
 COUNT(*) as total_matches 
 from (
   select team1 as team from [BBL_Matches 2011-2019]
   union all 
   select team2 as team from [BBL_Matches 2011-2019]
   ) as Teams
   group by team
   ),
   team_fours_sixes as (
   select batting_team as team,
   SUM(case when total_runs = 4 then 1 else 0 end) as total_fours,
   SUM(case when total_runs = 6 then 1 else 0 end) as total_sixes
   from [BBL_Ball_by_Ball ]
   group by batting_team
   )
   select tm.team,tm.total_matches,fs.total_fours,fs.total_sixes 
   from Team_Matches as tm
   left join Team_fours_sixes as fs on tm.team= fs.team
   order by tm.team;

  -------- most plyer of the match winner 
 create view pom
 as
 select player_of_match as 'Player' ,winner as 'Team',
 count(*) 'most'
 from [BBL_Matches 2011-2019]
 group by player_of_match, winner
 --order by most desc
 ;

 select Team = 'Adelaide Strikers', Player from pom

------  toss decisions after winning toss
Select toss_decision, count(toss_decision) as toss_decision
from [BBL_Matches 2011-2019]
where toss_decision is not null
group by toss_decision;

--------- toss decisions in each venue 
Select city,venue, toss_decision, count(toss_decision) as toss_decisionss
from [BBL_Matches 2011-2019]
where toss_decision is not null
group by venue,toss_decision,city;

---------- first batting winner and chasing winner 
select city,venue, team1,team2,venue,winner,result, result_margin
from [BBL_Matches 2011-2019]
where result ='runs'
group by city,venue, team1,team2,venue,winner,result,result_margin;


select city,venue, team1,team2,venue,winner,result, result_margin
from [BBL_Matches 2011-2019]
where result ='wickets'
group by city,venue, team1,team2,venue,winner,result,result_margin;

---------- runs in innings first five overs
Select  [BBL_Ball_by_Ball ].id, date,city,venue,inning,batting_team, overs, ball,total_runs, batsman,non_striker, bowler,
sum(total_runs) over (order by overs, ball) as running_total_runs
from [BBL_Ball_by_Ball ]
join [BBL_Matches 2011-2019]
on [BBL_Matches 2011-2019].id = [BBL_Ball_by_Ball ].id
where  overs <= 5 and [BBL_Ball_by_Ball ].id=524915 and batting_team= 'Brisbane Heat';

Select  [BBL_Ball_by_Ball ].id, date,city,venue,inning,batting_team, overs, ball,total_runs, batsman,non_striker, bowler,
sum(total_runs) over (order by overs, ball) as running_total_runs
from [BBL_Ball_by_Ball ]
join [BBL_Matches 2011-2019]
on [BBL_Matches 2011-2019].id = [BBL_Ball_by_Ball ].id
where  overs <= 5 and [BBL_Ball_by_Ball ].id=524915 and batting_team= 'Sydney Sixers';

--------- total runs in first innings
Select  [BBL_Ball_by_Ball ].id, date,city,venue,inning,batting_team, overs, ball,total_runs, batsman,non_striker, bowler,
sum(total_runs) over (order by overs, ball) as running_total_runs
from [BBL_Ball_by_Ball ]
join [BBL_Matches 2011-2019]
on [BBL_Matches 2011-2019].id = [BBL_Ball_by_Ball ].id
where   [BBL_Ball_by_Ball ].id=524915 and batting_team= 'Brisbane Heat';

---------- total runs in second innings
Select  [BBL_Ball_by_Ball ].id, date,city,venue,inning,batting_team, overs, ball,total_runs, batsman,non_striker, bowler,
sum(total_runs) over (order by overs, ball) as running_total_runs
from [BBL_Ball_by_Ball ]
join [BBL_Matches 2011-2019]
on [BBL_Matches 2011-2019].id = [BBL_Ball_by_Ball ].id
where   [BBL_Ball_by_Ball ].id=524915 and batting_team= 'Sydney Sixers';

----- total wides in each innings
select [BBL_Ball_by_Ball ].id, date, venue, bowling_team, extras_type
from [BBL_Ball_by_Ball ]
 join [BBL_Matches 2011-2019]
 on [BBL_Ball_by_Ball ].id=[BBL_Matches 2011-2019].id
 where [BBL_Ball_by_Ball ].id = 524915 and extras_type != 'NA';

 ----------- team won by result margin using store procedure
 create proc spget_teamwinningmargin
 @winner nvarchar(200) , @result nvarchar(200)
 as
 begin
 select [BBL_Matches 2011-2019].id, date,venue,winner,result,result_margin
 from [BBL_Matches 2011-2019]
 where winner in(select * from string_split(@winner,',')) and result in(select * from string_split(@result,',')) 
 group by [BBL_Matches 2011-2019].id, date,venue,winner,result,result_margin
 order by result_margin desc , date asc
 end;

 exec spget_teamwinningmargin @winner='Sydney Sixers', @result='wickets,runs';

 ------- most matches host by venue and  decision after toss
 Select city,venue,Count(*) as 'No of Matches',toss_decision, result
 from [BBL_Matches 2011-2019]
 group by city,venue,toss_decision,result;


 


