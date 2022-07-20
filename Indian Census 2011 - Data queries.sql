Select *
FROM [Project Indian Census 2011].dbo.Sheet2

-- number of rows into our dataset

select count(*)
FROM [Project Indian Census 2011]..Sheet1

select count(*)
FROM [Project Indian Census 2011]..Sheet2

-- dataset for jharkhand and bihar

select *
from [Project Indian Census 2011]..sheet1
where state in ('Jharkhand', 'Bihar')

-- population of India

select SUM(population) as Population_of_India
from [Project Indian Census 2011]..Sheet2

-- avg growth

Select avg(growth)*100 as avg_growth
from [Project Indian Census 2011]..Sheet2

-- avg growth by state

select state, avg(growth)*100 as avg_growth_by_state
from [Project Indian Census 2011]..Sheet2
group by State
order by 1 desc

-- avg sex ratio

select state, round(avg([Sex-Ratio]),0) as avg_sex_ratio
from [Project Indian Census 2011]..Sheet2
group by State
order by 2 desc

-- avg literacy rate

select state, round(avg([Literacy]),0) as avg_literacy_ratio
from [Project Indian Census 2011]..Sheet1
group by State
having round(avg([Literacy]),0) > 90
order by 2 desc

-- top 3 states with highest growth ratio

select top 3 state, avg(growth)*100 as avg_growth_by_state
from [Project Indian Census 2011]..Sheet2
group by State
order by 2 desc

-- bottom 3 states showing lowest sex ratio

select top 3 state, round(avg([Sex-Ratio]),0) as avg_sex_ratio
from [Project Indian Census 2011]..Sheet2
group by State
order by 2 asc

-- top and bottom 3 states in literacy rates

drop table if exists #topstates;
create table #topstates
( state nvarchar(255), topstate float

)

insert into #topstates
select state, round(avg(Literacy),0) as avg_literacy_ratio
from [Project Indian Census 2011]..Sheet1
group by State
order by avg_literacy_ratio desc;

select top 3 * 
FROM #topstates
order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255), bottomstate float

)

insert into #bottomstates
select state, round(avg(Literacy),0) as avg_literacy_ratio
from [Project Indian Census 2011]..Sheet1
group by State
order by avg_literacy_ratio desc;

select top 3 * 
FROM #bottomstates
order by #bottomstates.bottomstate asc;

-- union operator

select * from (
select top 3 * 
FROM #topstates
order by #topstates.topstate desc) a
UNION
select * from (
select top 3 * 
FROM #bottomstates
order by #bottomstates.bottomstate asc) b;

-- states starting with letter a

select distinct State
from [Project Indian Census 2011]..Sheet1
where lower(state) like 'a%' or lower(state) like 'b%'

-- states starting with letter a and ending with m

select distinct State
from [Project Indian Census 2011]..Sheet1
where lower(state) like 'a%' and lower(state) like '%m'