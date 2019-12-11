/* refresh table of adult patients who received only heart transplant with info contained in status output file */
/* used for obtaining the tier information for the recorded active status window at the time of transplant */
drop table if exists tsam2011tx_strict_valid_status_window;
create table tsam2011tx_strict_valid_status_window as 
	(
    /* iteration number, urgent status, patientid is included in the table */
    select g.iter as iter, s.curheartstat as status, g.patientid
    /* inner join of output graft file and output status file */
    from tsam_strict_graft g inner join tsam_strict_status s on (g.iter = s.iter and g.patientid = s.patientid)
    /* patients must be 18 or up when they enter the model */
    where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                          union select wl_id from public.patients20092011_usc where can_age >= 18) 
    	/* patients must be active at the time of transplant and must be heart transplant only patients */
    	and s.curheartstat in ('1', '1A', '1B', '2') and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
    	/* time of transplant must be included in the status file */
    	and ((date(g.eventtime) >= s.canhx_begin_dt and s.canhx_end_dt >= date(g.eventtime))
    		or
        	(date(g.eventtime) >= s.canhx_begin_dt and s.canhx_end_dt is null))
	group by g.iter, g.patientid, s.curheartstat
    );



/* refresh table of heart trasnplant patients */
/* used for obtaining the tier information for the last recorded active status window */
drop table if exists tsam2011tx_strict_last_tier_status;
create table tsam2011tx_strict_last_tier_status as 
	(
	/* iteration number, last status entry begin time, patientid is included in the table */
    select g.iter, max(s.canhx_begin_dt) as max_canhx_begin_dt, g.patientid 
    /* inner join of output graft file and output status file */
    from tsam_strict_graft g inner join tsam_strict_status s on (g.iter = s.iter and g.patientid = s.patientid) 
    /* patients must be 18 or up when they enter the model */
    where s.patientid in (select wl_id from public.waitlist20092011_usc where can_age >= 18 
                          union select wl_id from public.patients20092011_usc where can_age >= 18) 
    	/* patients must be active  and must be heart transplant only patients */
        and s.curheartstat in ('1', '1A', '1B', '2') and g.gotheart = true and g.gotleftlung = false and g.gotrightlung = false 
    group by g.iter, g.patientid, s.curheartstat
	);