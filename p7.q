DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT, team STRING, league STRING, games INT, ab INT, runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/batting';
DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, fname STRING, lname STRING, name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, finalgame STRING, retro STRING, bbref STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/master';


select rankdobid
from (select mstr.dobid as rankdobid, DENSE_RANK() OVER(ORDER BY mstr.dobcount desc) as rankval 
	  from
		(select CONCAT(master.bcity,'/',master.bstate) as dobid, sum(batting.doubles + batting.triples) as dobcount 
 		from master, batting
 		where master.id = batting.id and master.bcity is not null and master.bstate is not null
 	  group by CONCAT(master.bcity,'/',master.bstate) ) mstr 
 ) rankmaster
 where rankval <= 5;