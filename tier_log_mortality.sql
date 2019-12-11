COPY (
select curheartstat, min(cr), avg(cr), max(cr) 
from(
    select u.iter, u.curheartstat, (u.c*36500/v.time) as cr
    from(
        select iter as iter, curheartstat as curheartstat, count(*) as c 
        from public.tsam_relaxed_death 
        where patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                            union select wl_id from public.patients20092011_usc where can_age >= 18) 
              and needheart = true and needlungs = false and gotheart is null 
        group by iter, curheartstat 
        ) u 
inner join 
        (
        select z.iter, z.status, sum(z.waittime) as time
            from 
                (
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, d.snapdate)))) as waittime 
                from tsam_relaxed_status s inner join tsam_relaxed_death d on (s.iter = d.iter and s.patientid = d.patientid) 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                group by s.iter, s.curheartstat
                union
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, g.eventtime)))) as waittime 
                from tsam_relaxed_status s inner join tsam_relaxed_graft g on (s.iter = g.iter and s.patientid = g.patientid) 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
                group by s.iter, s.curheartstat
                union
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt)))) as waittime 
                from tsam_relaxed_status s 
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    and s.needheart = true and s.needlungs = false
                    and s.patientid not in (select distinct patientid from tsam_relaxed_graft union select distinct patientid from tsam_relaxed_death) 
                group by s.iter, s.curheartstat 
            	) as z 
            group by z.iter, z.status 
        ) v on (u.iter = v.iter and u.curheartstat = v.status) 
    where u.curheartstat in ('1A','1B','2') 
) t
group by curheartstat
order by curheartstat
) TO 'C:\TSAM\PostgresSQLcode\mortality_rate.csv' (format CSV);