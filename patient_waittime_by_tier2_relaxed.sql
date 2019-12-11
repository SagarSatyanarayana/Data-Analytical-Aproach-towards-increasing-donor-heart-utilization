COPY ( 
select x.iter, x.status, sum(x.waittime)
from ( 
        select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least('2011-6-30', s.canhx_end_dt, g.eventtime)))) as waittime 
        from public.tsam_relaxed_status s inner join tsam_relaxed_graft g on (s.patientid = g.patientid) 
        where s.patientid in (select z.wl_id from (select wl_id as wl_id from public.waitlist20092011_usc where can_age >= 18 group by wl_id 
        union 
        select wl_id as wl_id from public.patients20092011_usc where can_age >= 18 group by wl_id )as z) 
            and s.needheart = 'true' and s.needlungs = 'false'  and s.curheartstat = '1A' /*or s.curheartstat = '1B' or s.curheartstat = '2')*/ 
            /*and (s.tier = 1 or s.tier = 2 or s.tier = 3)*/ and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
        group by s.iter, s.curheartstat
        union 
        select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least('2011-6-30', s.canhx_end_dt, g.eventtime)))) as waittime 
        from public.tsam_relaxed_status s inner join tsam_relaxed_graft g on (s.patientid = g.patientid) 
        where s.patientid in (select z.wl_id from (select wl_id as wl_id from public.waitlist20092011_usc where can_age >= 18 group by wl_id
        union select wl_id as wl_id from public.patients20092011_usc where can_age >= 18 group by wl_id )as z) 
            and s.needheart = 'true' and s.needlungs = 'false' and s.curheartstat = '1B' /*or s.curheartstat = '1B' or s.curheartstat = '2') 
            and (s.tier = 4)*/ and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
        group by s.iter, s.curheartstat
        union 
        select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least('2011-6-30', s.canhx_end_dt, g.eventtime)))) as waittime 
        from public.tsam_relaxed_status s inner join tsam_relaxed_graft g on (s.patientid = g.patientid) 
        where s.patientid in (select z.wl_id from (select wl_id as wl_id from public.waitlist20092011_usc where can_age >= 18 group by wl_id 
                                                     union select wl_id as wl_id from public.patients20092011_usc where can_age >= 18 group by wl_id )as z) 
            and s.needheart = 'true' and s.needlungs = 'false'  and s.curheartstat = '2' /*or s.curheartstat = '1B' or s.curheartstat = '2'
            and (s.tier = 5 or s.tier = 6)*/ and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
        group by s.iter, s.curheartstat 
        union 
        select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least('2011-6-30', s.canhx_end_dt)))) as waittime 
        from public.tsam_relaxed_status s 
        where s.patientid in (select z.wl_id from (select wl_id as wl_id from public.waitlist20092011_usc where can_age >= 18 group by wl_id 
                                                     union select wl_id as wl_id from public.patients20092011_usc where can_age >= 18 group by wl_id )as z) 
            and s.needheart = 'true' and s.needlungs = 'false' and s.canhx_end_dt is not null and (s.curheartstat = '1A' or s.curheartstat = '1B' or s.curheartstat = '2') 
            and s.patientid not in (select distinct patientid from tsam_relaxed_graft where gotheart = true and gotleftlung = false and gotrightlung = false) 
        group by s.iter, s.curheartstat
        union 
        select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, '2011-6-30'))) as waittime 
        from public.tsam_relaxed_status s 
        where s.patientid in (select z.wl_id from (select wl_id as wl_id from public.waitlist20092011_usc where can_age >= 18 group by wl_id 
                                                     union select wl_id as wl_id from public.patients20092011_usc where can_age >= 18 group by wl_id )as z) 
            and s.needheart = 'true' and s.needlungs = 'false' and s.canhx_end_dt is null and (s.curheartstat = '1A' or s.curheartstat = '1B' or s.curheartstat = '2') 
            and s.patientid not in (select distinct patientid from tsam_relaxed_graft where gotheart = true and gotleftlung = false and gotrightlung = false) 
        group by s.iter, s.curheartstat
        )as x 
group by x.iter, s.curheartstat
order by x.iter, s.curheartstat
) TO 'C:\TSAM\PostgresSQLcode - Copy\logistic_relaxed_waittime.csv' (format CSV);  