-- ========================================================================
-- Changing 1 value 'A' in a line item from selected samples to 'B'
-- ========================================================================
update		stg.Selected_Samples -- to update table
set			Distributor = case when Distributor = 'A' and [Col 2] = '1234' then replace(Distributor, 'A', 'B') else Distributor end    

-- ========================================================================
-- Using case when and cte
-- ========================================================================
if object_id('tempdb..#temp') is not null drop table #temp
go

with cte as(
	select *,
			case when [Col A] like '%LT%' then concat(replace([Col A],'LT',''),[Col B])
			else concat(left([Col A], 8),[Col B])
			end as [Dist Invoice Part Key]
			from stg.Selected_Samples -- 108 rows
)
select		a.ey_row_id, a.[Dist Invoice Part Key], a.[Distributor], b.[Resale Price Usd Ext Amt]
into		#temp
from		cte a
left join   src.POS_forEY_updated b
on			b.[DIST INVOICE-PART KEY] = a.[Dist Invoice Part Key]
where		b.[DIST INVOICE-PART KEY] is not NULL
-- 175 rows affected

