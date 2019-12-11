select u.iter, u.status, u.sum * 36500 / v.time as transplant_rate
    from 
    	( 
        /* find transplant count for each urgent status in each iteration */
        select x.iter as iter, x.status as status, sum(x.count) as sum 
        from 
        	( 
                /* find urgent status at the time of transplant using their status in output status file for each urgent status in each iteration */
                select iter as iter, status as status, count(*) as count 
                /* patients must have vaild status window in output status file */
                from tsam2011tx_relaxed_valid_status_window
                group by iter, status 
            union  	 
                /* find urgent status at the time of transplant using their last reported status in output status file for each urgent status in each iteration */
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                /* inner join of output status file and last urgent status info of heart transplant patient */
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                /* patients must not have vaild status window in output status file in iteration 0 */
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 0) and s.iter = 0 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 1) and s.iter = 1 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 2) and s.iter = 2 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 3) and s.iter = 3 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 4) and s.iter = 4 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 5) and s.iter = 5 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 6) and s.iter = 6 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 7) and s.iter = 7 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 8) and s.iter = 8 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 9) and s.iter = 9 
                group by s.iter, s.curheartstat 
            union  	 
                select s.iter as iter, s.curheartstat as status, count(*) as count 
                from public.tsam_relaxed_status s inner join tsam2011tx_relaxed_last_tier_status l on (s.iter = l.iter and s.patientid = l.patientid and s.canhx_begin_dt = l.max_canhx_begin_dt) 
                where s.patientid not in (select patientid from tsam2011tx_relaxed_valid_status_window where iter = 10) and s.iter = 10 
                group by s.iter, s.curheartstat 
            union
                /* find urgent status at the time of transplant using their status when they enter the model */
                /* patients who do not have information in output status file */ 
                select g.iter as iter, p.curheartstat as status, count(*) as count
                /* inner join of output graft file and input patient arrival file */
                from tsam_relaxed_graft g inner join patients20092011_usc p on g.patientid = p.wl_id 
                /* patients must be 18 or up when they enter the model */
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    /* patients must not be included in output status file in iteration 0 */
                	and g.patientid not in (select distinct patientid from tsam_relaxed_status where iter = 0) and g.iter = 0 
                    /* patients must be active at the time of transplant and must be heart transplant only patients */
                	and p.curheartstat in ('1', '1A', '1B', '2') and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false   
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 1) and g.iter = 1 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 2) and g.iter = 2 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 3) and g.iter = 3 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 4) and g.iter = 4 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 5) and g.iter = 5 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 6) and g.iter = 6 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 7) and g.iter = 7 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 8) and g.iter = 8 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 9) and g.iter = 9 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
            union
                select g.iter as iter, p.curheartstat as status, count(*) as count
                from public.tsam_relaxed_graft g inner join public.patients20092011_usc p on g.patientid = p.wl_id 
                where g.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                                      union select wl_id from public.patients20092011_usc where can_age >= 18)
                    and g.patientid not in (select distinct patientid from public.tsam_relaxed_status where iter = 10) and g.iter = 10 
                    and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false and p.curheartstat in ('1', '1A', '1B', '2') 
                group by g.iter, p.curheartstat 
        	) as x 
        	group by x.iter, x.status 
    	) as u 
    inner join 
		(
        /* find total waittime for each urgent status in each iteration */
        select z.iter, z.status, sum(z.waittime) as time
        from 
            (
            	/* find total waittime of patients died during model run for each urgent status in each iteration  */
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, d.snapdate)))) as waittime 
            	/* inner join of output death file and output status file */
                from tsam_relaxed_death d inner join tsam_relaxed_status s on (d.iter = s.iter and d.patientid = s.patientid) 
            	/* patients must be 18 or up when they enter the model */
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                  	union select wl_id from public.patients20092011_usc where can_age >= 18) 
                	/* patients must be heart transplant only patients */
                	and s.needheart = true and s.needlungs = false
            	group by s.iter, s.curheartstat
            union
                /* find total waittime of patients received transplant during model run for each urgent status in each iteration  */
            	select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt, g.eventtime)))) as waittime  
            	/* inner join of output graft file and output status file */
                from tsam_relaxed_graft g inner join tsam_relaxed_status s on (g.iter = s.iter and g.patientid = s.patientid) 
                /* patients must be 18 or up when they enter the model */
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    /* patients must be heart transplant only patients and must have heart transplant during model run*/
                	and s.needheart = true and s.needlungs = false and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
                group by s.iter, s.curheartstat
            union
                /* find total waittime of patients neither died nor received transplant during model run for each urgent status in each iteration  */
                select s.iter as iter, s.curheartstat as status, sum(greatest(0, DateDiff('day', s.canhx_begin_dt, least(to_date('2011-06-30', 'YYYY-MM-DD'), s.canhx_end_dt)))) as waittime
                from public.tsam_relaxed_status s 
                /* patients must be 18 or up when they enter the model */
                where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18
                                      union select wl_id from public.patients20092011_usc where can_age >= 18) 
                    /* patients must be heart transplant only patients */
                	and s.needheart = true and s.needlungs = false
                    /* patients must neither died nor received transplant */
                	and s.patientid not in (select distinct patientid from tsam_relaxed_graft union select distinct patientid from tsam_relaxed_death) 
                group by s.iter, s.curheartstat 
            ) as z 
            group by z.iter, z.status 
		) as v on (u.iter = v.iter and u.status = v.status)
    where u.status in ('1', '1A', '1B', '2')
    order by u.status, u.iter;