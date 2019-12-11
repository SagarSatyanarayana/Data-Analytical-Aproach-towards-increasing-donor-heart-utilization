COPY (
/* find min, average and max of mortality rate for each urgent status */
select w.curheartstat, min(mortality_rate), avg(mortality_rate), max(mortality_rate) 
from 
    (
    /* find mortality rate (per 100 patient year) for each urgent status in each iteration */
    select y.iter, y.curheartstat, y.count * 36500 / t.time as mortality_rate
    from 
        (
        /* find mortality count for each urgent status in each iteration */
        select u.iter as iter, v.curheartstat as curheartstat, count (*) as count 
        from 
            ( 
            	(
                /* find patientid and last status window begin time in each iteration */
                select d.iter as iter, d.patientid as patientid, max(s.canhx_begin_dt) as max_canhx_begin_dt
                 /* inner join of output death file and output status file */
                from tsam_strict_death d inner join tsam_strict_status s on (d.iter = s.iter and d.patientid = s.patientid) 
                /* patients must be 18 or up when they enter the model */
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    /* patients must be active at the time of death and must be heart transplant only patients */
                    and s.curheartstat in ('1','1A','1B','2') and d.needheart = true and d.needlungs = false and d.gotheart is null
                group by d.iter, d.patientid
            	) u 
            inner join 
            	public.tsam_strict_status v on (u.iter = v.iter and u.patientid = v.patientid and u.max_canhx_begin_dt = v.canhx_begin_dt)
        	) group by u.iter, v.curheartstat 
    	) y 
    inner join 
        (
            select z.iter, z.status, sum(z.waittime) as time
            from 
                (
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, d.snapdate)))) as waittime 
                from public.tsam_strict_status s inner join tsam_strict_death d on (s.iter = d.iter and s.patientid = d.patientid) 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                group by s.iter, s.curheartstat
                union
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, g.eventtime)))) as waittime 
                from public.tsam_strict_status s inner join tsam_strict_graft g on (s.iter = g.iter and s.patientid = g.patientid) 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
                group by s.iter, s.curheartstat
                union
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt)))) as waittime 
                from public.tsam_strict_status s 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                    and s.patientid not in (select distinct patientid from tsam_strict_graft union select distinct patientid from tsam_strict_death) 
                group by s.iter, s.curheartstat 
            	) as z 
            group by z.iter, z.status 
            /*
            select z.iter as iter, z.tier as tier, sum(z.waittime) as time
            from 
                (
                 select s.iter as iter, s.urg_stat as tier, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, g.eventtime)))) as waittime 
                     from public.orgpres2011status s inner join orgpres2011graft g on (s.iter = g.iter and s.patientid = g.patientid) 
                     where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                           union select wl_id from public.patients20092011_usc where can_age >= 18) 
                           and s.needheart = true and s.needlungs = false
                           and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
                     group by s.iter, s.urg_stat
                 union
                     select s.iter as iter, s.urg_stat as tier, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt)))) as waittime 
                     from public.orgpres2011status s 
                     where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                           union select wl_id from public.patients20092011_usc where can_age >= 18) 
                           and s.needheart = true and s.needlungs = false
                           and s.patientid not in (select distinct patientid from orgpres2011graft) 
                     group by s.iter, s.urg_stat 
                 ) z group by z.iter, z.tier 
            */
        ) t on (y.iter = t.iter and y.curheartstat = t.status)
    where y.curheartstat in ('1','1A','1B','2') 
) w
group by w.curheartstat
order by w.curheartstat
) TO 'C:\TSAM\PostgresSQLcode - Copy\logistic_strict_mortality_rate.csv' (format CSV);