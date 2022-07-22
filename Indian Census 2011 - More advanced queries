SELECT *
FROM [Project Indian Census 2011]..Data1

SELECT *
FROM [Project Indian Census 2011]..Data2

-- joining both tables on district
-- using following formula to split out male vs females numbers: 
-- males = population / (sex_ratio + 1)
-- females = population - (population/(sex_ratio + 1))
-- total males and females
-- grouping by state

select d.state, sum(d.males) total_males, sum(d.females) total_females from
(select c.district, c.state, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females
from
(select a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population
from [Project Indian Census 2011]..data1 a
inner join
[Project Indian Census 2011]..data2 b
on a.district = b.district) c) d
group by d.state;

-- total literacy rate, percentage of the population that can read or write
 
select d.state, sum(literate_people) total_literate_pop , sum(illiterate_people) total_illiterate_population from
(select c.district,c.state,round((c.literacy_ratio * c.population),0) literate_people, round (((1-c.literacy_ratio)* c.population),0) illiterate_people from
(select a.district, a.state, a.literacy/100 literacy_ratio, b.population
from [Project Indian Census 2011]..data1 a
inner join
[Project Indian Census 2011]..data2 b
on a.district = b.district) c) d
group by d.state

-- calculating population in previous census


select sum(m.previous_census_pop) total_previous_population, sum(m.current_census_pop) total_current_population from
(select d.state, sum(d.previous_census_population) previous_census_pop, sum(d.current_census_population) current_census_pop from
(select c.district, c.state, round((c.population/(1+c.growth)), 0) previous_census_population, round(c.population, 0) current_census_population from
(select a.district, a.state, a.growth growth, b.population
from [Project Indian Census 2011]..data1 a
inner join
[Project Indian Census 2011]..data2 b
on a.district = b.district) c) d
group by d.state) m

-- population vs area

select g.total_previous_population / g.total_area pop_vs_area, g.total_current_population / g.total_area pop_vs_area from
(select q.*,r.total_area from (
-- need to change to r.total area as both columns cant have same name

select '1' as keyy,n. * from
-- joining both tables, need to add a common key. used word keyy as key already variable
(select sum(m.previous_census_pop) total_previous_population, sum(m.current_census_pop) total_current_population from
(select d.state, sum(d.previous_census_population) previous_census_pop, sum(d.current_census_population) current_census_pop from
(select c.district, c.state, round((c.population/(1+c.growth)), 0) previous_census_population, round(c.population, 0) current_census_population from
(select a.district, a.state, a.growth growth, b.population
from [Project Indian Census 2011]..data1 a
inner join
[Project Indian Census 2011]..data2 b
on a.district = b.district) c) d
group by d.state) m) n) q 
inner join 

(select '1' as keyy,z. * from (
select sum(area_km2) total_area
from [Project Indian Census 2011]..data2)z) r on q.keyy=r.keyy) g


-- window functions
-- top 3 districts with highest literacy rate from each state

select a.state, a.district, a.literacy, a.rnk from
(select district, state, literacy, rank() over(partition by state order by literacy desc) rnk from
[Project Indian Census 2011]..data1) a
where a.rnk in (1,2,3)
order by state

-- bottom 3 districts lowest highest literacy rate from each state

select a.state, a.district, a.literacy, a.rnk from
(select district, state, literacy, rank() over(partition by state order by literacy asc) rnk from
[Project Indian Census 2011]..data1) a
where a.rnk in (1,2,3)
order by state



