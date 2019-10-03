DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT, team STRING, league STRING, games INT, ab INT, runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/batting';
 DROP TABLE IF EXISTS fielding;
 CREATE EXTERNAL TABLE IF NOT EXISTS fielding (ID STRING, year INT, team STRING,lgID STRING,POS STRING,G INT,GS STRING,InnOuts STRING,PO STRING,A STRING, E INT,DP STRING,PB STRING,WP STRING,SB STRING,CS STRING,ZR STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding';
 
select rankid
from (select mstr.playerid as rankid, DENSE_RANK() OVER(ORDER BY mstr.equation desc) as rankval 
	  from
    (select fielding.id as playerid, (sum(batting.hits) / sum(batting.ab)) - (sum(fielding.e) / sum(fielding.g)) as equation
 		from fielding, batting
        where fielding.id = batting.id
        and fielding.year = batting.year
        and fielding.year >= 2005 and fielding.year <= 2009
		and (fielding.GS is not null or fielding.InnOuts is not null or fielding.PO is not null or fielding.A  is not null 
			 or fielding.E is not null or fielding.DP is not null or fielding.PB is not null or fielding.WP is not null 
			 or fielding.SB is not null or fielding.CS is not null or fielding.ZR is not null)
		and batting.hits is not null
		and batting.ab is not null
		and fielding.e is not null
		and fielding.g is not null
		group by fielding.id
        having (sum(fielding.g) >= 20 and sum(batting.ab) >= 40)) mstr
     ) rankmaster
     where rankval <= 3;  