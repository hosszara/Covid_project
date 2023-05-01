--there is too much data so first will select the data that we will only use for this project 

select population,continent,location,date,total_cases,new_cases,total_deaths,new_deaths,
total_vaccinations,people_vaccinated,people_fully_vaccinated from dbo.covid_data#csv$



--we need to get the sum of total cases deaths and vaccination per year 
select location, year(date) as year ,population , sum(new_cases) as all_cases,sum(new_deaths) as all_deaths,
max(people_vaccinated) as all_vaccinations
from dbo.covid_data#csv$
where location not in ('Africa','Asia','Europe','North America','World','European Union','High income','Upper middle income',
'Lower middle income') 

group by location, year(date),population
having max(people_vaccinated) is not null and  sum(new_cases) is not null
order by all_cases desc



--next will get the percentage of total deaths per continent
select continent, (sum(new_deaths)/ sum(new_cases)) * 100  as death_percentage from dbo.covid_data#csv$
where continent is not null

group by continent

--will get people vaccinated percentage per location
select location,max(people_vaccinated)/max(population) *100 as vaccination_perce from dbo.covid_data#csv$
where location not in ('Africa','Asia','Europe','North America','World','European Union','High income','Upper middle income',
'Lower middle income','South America','North America') 
group by location
 having  max(people_vaccinated)/max(population) *100  is not null
 order by 1

--will get the number of how many people did not vaccinate 

select location, max(population)- max(people_vaccinated) as ppl_not_vaccinated from dbo.covid_data#csv$
where location not in ('Africa','Asia','Europe','North America','World','European Union','High income','Upper middle income',
'Lower middle income','South America','North America') 

group by location
having max(population)- max(people_vaccinated) is not null
order by 1

--will show the rolling of population that have been fully vaccinated will use window_fuc rather than using sub_query

select year(date),location,max(people_fully_vaccinated) over(partition by location order by location) as rolling_people_vac
from dbo.covid_data#csv$
where location not in ('Africa','Asia','Europe','North America','World','European Union','High income','Upper middle income',
'Lower middle income','South America','North America') 







-- will try to add all in one query
--we need to get the sum of cases deaths and vaccination per year 
select continent, location, year(date) as year ,population , sum(new_cases) as all_cases,sum(new_deaths) as all_deaths,
max(people_vaccinated) as all_vaccinations, max(population)- max(people_vaccinated) as ppl_not_vaccinated,
max(people_vaccinated)/max(population) *100 as vaccination_percentage,max(total_deaths)/max(population) * 100 as death_perecent,
max(total_cases)/max(population) *100 as total_cases_precentage
from dbo.covid_data#csv$
where location not in ('Africa','Asia','Europe','North America','World','European Union','High income','Upper middle income',
'Lower middle income') 
and continent is not null
group by  continent,location, year(date),population
order by all_cases desc