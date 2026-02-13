-- Pipeline count by stage

Select deal_stage,count(*) pipeline_count
from sales_pipeline
group by deal_stage

-- Win % by Sales Rep

Select sales_agent ,count(opportunity_id) total_deals,
SUM(
CASE WHEN deal_stage ='Won' THEN 1 ELSE 0
END
) deals_won,
ROUND(SUM(
CASE WHEN deal_stage ='Won' THEN 1 ELSE 0
END
) :: decimal / count(opportunity_id) * 100,2) win_percent
from sales_pipeline
group by sales_agent
order by win_percent desc

---Revenue by month

Select
	EXTRACT(MONTH FROM close_date) close_month,
	SUM(close_value) monthly_revenue
from sales_pipeline
where deal_stage ='Won'
group by close_month
order by close_month

---Revenue by quarter

Select
	EXTRACT(QUARTER FROM close_date) close_quarter,
	SUM(close_value) quarterly_revenue
from sales_pipeline
where deal_stage ='Won'
group by close_quarter
order by close_quarter 

-- Loss % 

Select 
	count(opportunity_id) total_deals,
	SUM(
	CASE WHEN deal_stage ='Lost' THEN 1 ELSE 0
	END
	) deals_lost,
	ROUND(SUM(
		CASE WHEN deal_stage ='Lost' THEN 1 ELSE 0
		END
		) :: decimal / count(opportunity_id) * 100,2) loss_percent
from sales_pipeline
order by loss_percent desc


--- Top selling products
Select
	  product,
      SUM(close_value) total_sold
from sales_pipeline
where deal_stage='Won'
group by product
order by  SUM(close_value) desc