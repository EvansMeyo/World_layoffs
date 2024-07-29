Create database world_layoffs;
Use world_layoffs;

select*
from layoffs;



    #create a copy table
Create table layoff as
select * from layoffs; 

#1 Remove duplicates
#create another column with a unique identifier to detect duplicates by partitioning all columns
select*,
row_number() over(partition by company, industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions,stage, country) as rn
from layoffs;

#check the duplicates
with cte1 as
(select*,
row_number() over(partition by company, industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions,stage, country) as rn
from layoffs)

Select*
from cte1
where rn>1;

#create another copy table as above to delete duplicates
Create table layoffs2 as
select*,
row_number() over(partition by company, industry,total_laid_off,percentage_laid_off,`date`,funds_raised_millions,stage, country) as rn
from layoffs;

Delete
from layoffs2
where rn>1;


#standardizing data
select company, trim(company)
from layoffs2;

Update layoffs2
set company= trim(company);

select *
from layoffs2
where industry like 'crypto%';

#Update all rows like 'crypto%' to Crypto
Update layoffs2
set industry='Crypto'
where industry like 'Crypto%';

select distinct country
from layoffs2 
order by 1;

Update layoffs2
set country='USA'
where country like 'United States%';

#correct the date column
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs2 ;

update layoffs2
set `date`=str_to_date(`date`,'%m/%d/%Y');

Alter table layoffs2
modify `date` Date;

#nulls
#Populate data for nulls in industry
Select*
from layoffs
where industry is null or industry ='';

Update layoffs2 
set industry= null
where industry='';

Select t1.industry,t2.industry
from layoffs2 t1
Join layoffs2 t2
on t1.company=t2.company
where t1.industry is null and
t2.industry is not null;


Update layoffs2 t1
Join layoffs2 t2
on t1.company=t2.company
Set t1.industry=t2.industry
where t1.industry is null and
t2.industry is not null;

#delete rows with nulls in both total laid off and %laid off
Delete
from layoffs2
where total_laid_off is null and percentage_laid_off is null;

#delete unneeded columns
 Alter table layoffs2
 drop column rn;
 
 select*
 From layoffs2;
 
 
 #Exploratory data analysis (EDA)
 
 #Companies with 100% lay off
 select*
 From layoffs2
 where percentage_laid_off=1
 order by total_laid_off desc;
 
#total number laid-off during the period per company

 select company, sum(total_laid_off)
 From layoffs2
 group by company
 order by 2 desc;
 
 #total number laid-off during the period per industry
 
 select Industry, sum(total_laid_off)
 From layoffs2
 group by industry
 order by 2 desc;
 
 #total number laid-off during the period per country
 
 select country, sum(total_laid_off)
 From layoffs2
 group by country
 order by 2 desc;
 
 #laid off monthly
 
 select substring(`date`,1,7) as monthly_laid_offs, sum(total_laid_off) as totals
 From layoffs2
 where substring(`date`,1,7)  is not null
 group by monthly_laid_offs
 order by 1 asc;
 
 #rolling total

Select monthly_laid_offs, totals,sum(totals) over(order by monthly_laid_offs) as rolling_total
from(
select substring(`date`,1,7) as monthly_laid_offs, sum(total_laid_off) as totals
 From layoffs2
 where substring(`date`,1,7)  is not null
 group by monthly_laid_offs
 order by 1 asc)a;
 
 #or
 
 Select *,
 sum(total_laid_off) over( partition by substring(`date`,1,7)  order by substring(`date`,1,7)) as rolling_total
 From layoffs2
 where substring(`date`,1,7)  is not null
 order by substring(`date`,1,7) asc;


 #Top five companies with the highest laid off workers each year
 
 Select company,years, totals,
 dense_rank() over(partition by years order by totals desc) as ranking
 from (select company, substring(`date`,1,4) as years, sum(total_laid_off) as totals
 From layoffs2
 where substring(`date`,1,4)  is not null
 group by 1,2
 order by 3 desc)a;
 
 Select * from(
 Select company,years, totals, dense_rank() over(partition by years order by totals desc) as ranking
from (select company, substring(`date`,1,4) as years, sum(total_laid_off) as totals
 From layoffs2
 where substring(`date`,1,4)  is not null
 group by company, years
 order by 1,2 asc)a)b
 where ranking<6;
 






