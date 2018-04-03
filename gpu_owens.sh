#!/usr/bin/env bash
#
# Author: Summer Wang (xwang@osc.edu) 
# Modified: 2/19/18
#
# This script queries the jobs database to get the GPU report. 
#

echo "Enter the start date from which the report is generate (yyyy-mm-dd). For example, July 01, 2017 is 2017-7-1."
read  s_date
echo "Enter the end date by which the report is generate (yyyy-mm-dd). For example, July 01, 2017 is 2017-7-1."
read e_date

mysql -hdbsys01.infra -uwebapp pbsacct --execute=" 
SELECT '$s_date' AS startDate, '$e_date' AS endDate;
SELECT username, COUNT(jobid) AS jobcount, MAX(TIMESTAMPDIFF(second, FROM_UNIXTIME(submit_ts), FROM_UNIXTIME(start_ts))/3600.0) as max, MIN(TIMESTAMPDIFF(second, FROM_UNIXTIME(submit_ts), FROM_UNIXTIME(start_ts))/3600.0 ) as min, AVG( TIMESTAMPDIFF(second, FROM_UNIXTIME(submit_ts), FROM_UNIXTIME(start_ts))/3600.0) as avg from Jobs where system like 'owens' and ( start_date >= '$s_date' AND start_date <= '$e_date' ) and nodes like '%gpus%' GROUP BY username;
"
