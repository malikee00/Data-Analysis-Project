-- create join table
select * 
from absenteeism_at_work
left join compensation on absenteeism_at_work.ID = compensation.ID
left join reasons on absenteeism_at_work.`Reason for absence` = reasons.Number;

-- find the healthies for the bonus
select * from absenteeism_at_work 
where `Social drinker` = 0 and `Social smoker` = 0
and `Body mass index` < 25 and 
`Absenteeism time in hours` < (select avg(`Absenteeism time in hours`) from absenteeism_at_work);

-- compensation rate increase for non smoker / bugdet 983,221 so .68 increase per hour/ $1,414.4
select count(*) as nonsmokers from absenteeism_at_work
where `Social smoker` = 0;

-- optimize the query 
select 
absenteeism_at_work.ID,
reasons.Reason,
`Month of absence`,
`Body mass index`,
case when `Body mass index` < 18.5 then 'Underweight'
	when `Body mass index` between 18.5 and 24.9 then 'Healthy Weight'
    when `Body mass index` between 25 and 30 then 'Overweight'
    when `Body mass index` > 18.5 then 'Obese'
    else 'Unknown' end as BMI_categories,
case when `Month of absence` in (12, 1, 2) then 'Winter'
	when `Month of absence` in (3, 4, 5) then 'Spring'
	when `Month of absence` in (6, 7, 8) then 'Summer'
	when `Month of absence` in (9, 10, 11) then 'Fall'
    else 'Unkown' end as Season_names,
`Seasons`,
`Month of absence`,
`Day of the week`,
`Transportation expense`,
`Education`,
`Son`,
`Social drinker`,
`Social smoker`,
`Pet`,
`Disciplinary failure`,
`Age`,
`Work load Average/day`, 
`Absenteeism time in hours`
from absenteeism_at_work
left join compensation on absenteeism_at_work.ID = compensation.ID
left join reasons on absenteeism_at_work.`Reason for absence` = reasons.Number;