 DROP TABLE IF EXISTS fielding;
 CREATE EXTERNAL TABLE IF NOT EXISTS fielding (ID STRING, year INT, team STRING,lgID STRING,POS STRING,G STRING,GS STRING,InnOuts STRING,PO STRING,A STRING, E INT,DP STRING,PB STRING,WP STRING,SB STRING,CS STRING,ZR STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding';
 
 select rankid
from (select mstr.playerid as rankid, DENSE_RANK() OVER(ORDER BY mstr.teamcount desc) as rankval 
	  from
		(select fielding.id as playerid, sum(fielding.e) as teamcount 
 		from fielding
 	  group by fielding.id ) mstr 
 ) rankmaster
 where rankval = 1;