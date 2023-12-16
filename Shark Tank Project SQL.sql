/*
Shark Tank India Data Exploration

Skills used: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-------------------------------------------------------------------------------------------------------------------------------

select * from project..data
  

-- Total number of episodes telecasted

select count(distinct epno)
from project..data
  

-- Total number of pitches 

select count(distinct brand) 
from project..data
  

-- Percentage of pitches that received funding

select cast(sum(C_NC.converted/not_converted) as float) /cast(count(*) as float) 
from (
      select amountinvestedlakhs, 
      case 
        when amountinvestedlakhs>0 then 1 else 0 
      end as converted/not_converted from project..data) C_NC

  
-- Total number of Male pitchers

select sum(male) 
from project..data
  

-- Total number of Female pitchers

select sum(female) 
from project..data
  

-- Gender ratio of pitchers

select sum(female)/sum(male) 
from project..data
  

-- Total amount invested by sharks

select sum(amountinvestedlakhs)
from project..data
  

-- Average equity percentage aquired by sharks

select avg(a.equitytakenp) 
from (
      select * 
      from project..data 
      where equitytakenp>0) a
  

-- Highest amount invested in a single deal

select max(amountinvestedlakhs) 
from project..data
  

-- Highest equity percentage aquired in a single deal

select max(equitytakenp) 
from project..data
  

-- Total number of pitches with atleast 1 Female

select sum(FC.female_count) at_least_1_Female 
from (
      select female,
      case 
        when female>0 then 1 else 0 
      end as female_count 
      from project..data) FC
  

-- Total number of pitches that received funding, having at least 1 Female

select sum(b.female_count) 
from(
      select 
      case 
        when a.female>0 then 1 else 0 
      end as female_count, a.* 
      from (
            (select * 
              from project..data 
              where deal!='No Deal')
            ) a
      )b
  

-- Average number of team members in a single pitch

select avg(teammembers) 
from project..data
  

-- Average amount invested per deal

select avg(a.amountinvestedlakhs) amount_invested_per_deal 
from (
      select * 
      from project..data 
      where deal!='No Deal') a
  

-- Age group with highest number of pitchers

select avgage,count(avgage) AgeGroup 
from project..data 
group by avgage
order by AgeGroup desc
  

-- Places from which highest number of pitchers came from

select location,count(location) CountLocation 
from project..data 
group by location 
order by CountLocation desc

  
-- Sectors with highest number of pitches

select sector,count(sector) CountSector
from project..data 
group by sector 
order by CountSector desc


-- Number of deals involving a single shark or 2 or more sharks (partner/joint deals)

select partners,count(partners) CountPartners 
from project..data 
where partners!='-'
group by partners 
order by CountPartners desc

  
-- Amount Invested/ Average Equity Aquired/ Total Episodes/ Total Deals for individual shark (Ashneer Grover)

select * from project..data

select 'Ashneer' as keyy,count(ashneeramountinvested) 
from project..data 
where ashneeramountinvested is not null AND ashneeramountinvested!=0

SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED),AVG(C.ASHNEEREQUITYTAKENP) 
FROM (
      SELECT * 
      FROM PROJECT..DATA 
      WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C


select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken 
from (
      select a.keyy,a.total_deals_present,b.total_deals 
      from(
            select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals_present 
            from project..data 
            where ashneeramountinvested is not null) a

            inner join (
                        select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals 
                        from project..data 
                        where ashneeramountinvested is not null AND ashneeramountinvested!=0) b 
            on a.keyy=b.keyy
      ) m

inner join (
            SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED) total_amount_invested, AVG(C.ASHNEEREQUITYTAKENP) avg_equity_taken
            FROM (SELECT * 
                  FROM PROJECT..DATA 
                  WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C
            ) n
on m.keyy=n.keyy
  

-- Startup with highest amount invested in for each sector

select c.* 
from (
      select brand,sector,amountinvestedlakhs,rank() over(partition by sector order by amountinvestedlakhs desc) rnk 
      from project..data) c
where c.rnk=1
