select * from teams_d;
update teams_d set team_id =104 where team_name='mi';

select * from match_records;

with win as (select winning_team_id,count(winning_team_id)as win_point,sum(goal_by_won)as goal
from match_records 
group by winning_team_id),

lose as (select loosing_team_id,count(loosing_team_id)as lose_point
from match_records 
group by loosing_team_id)

--select winning_team_id , rank()over(order by points desc,goal desc)as rnk from (select winning_team_id ,win_point-lose_point as points,goal from win w inner join lose l on w.winning_team_id =l.loosing_team_id)

select team_name , team_id,rank()over(order by points desc,goal desc)as rnk 
from (select winning_team_id ,win_point-lose_point as points,goal from win w inner join lose l on w.winning_team_id =l.loosing_team_id)w
inner join teams_d t on w.winning_team_id=t.team_id


--select winning_team_id ,win_point-lose_point as points,goal from win w inner join lose l on w.winning_team_id =l.loosing_team_id
--order by points desc,goal desc

--select winning_team_id , row_number()over(order by points desc,goal desc)as rnk from (select winning_team_id ,win_point-lose_point as points,goal from win w inner join lose l on w.winning_team_id =l.loosing_team_id)