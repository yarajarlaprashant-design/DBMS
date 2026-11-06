create database cricketers;

create table Players (
Player_Id        int            primary key,
Player_Name      varchar(40)    not null,
Player_Age       int            not null,
Gender           char(10)       not null,
Role             char(30)       not null,
Player_Country   varchar(30)    not null
)

insert into Player values(101,'Kohli',37,'Male','Batsman','India')
insert into Player values(102,'Dhoni',42,'Male','Wicketkeeper','India')
insert into Player values(103,'Rohit',39,'Male','Batsman','India')
insert into Player values(104,'Cummins',33,'Male','Bowler','Australia')
insert into Player values(105,'Harry Brook',27,'Male','Batsman','England')
insert into Player values(106,'Dewald Brevis',23,'Male','Batsman','South Africa')
insert into Player values(107,'Nitish',22,'Male','All Rounder','India')
insert into Player values(108,'Sharma Abhishek',26,'Male','Batsman','India')
insert into Player values(109,'Bishnoi',24,'Male','Bowler','India')
insert into Player values(110,'Rashid Khan',27,'Male','Bowler','Afghanistan')
insert into Player values(111,'Bishnoi',24,'Male','Bowler','India')
insert into Player values(112,'Joseph',26,'Male','Bowler','West Indies')
insert into Player values(113,'Kane',37,'Male','Batsman','New Zealand')
insert into Player values(114,'Temba Bavuma',32,'Male','Batsman','South Africa')
insert into Player values(115,'Abd',46,'Male','Batsman','South Africa')
insert into Player values(116,'Sachin',52,'Male','Batsman','India')



create table Team (
Team_Id          int            primary key,
Team_Name        varchar(30)    not null,
Team_Country     varchar(30)    not null,
Coach            varchar(40)    not null,
Ranking          int            not null
)

insert into Team values(201,'India','India','Gautam',1)
insert into Team values(202,'Australia','Australia','Andrew',2)
insert into Team values(203,'South Africa','South Africa','Shukri',3)
insert into Team values(204,'New Zealand','New Zealand','Rob',4)
insert into Team values(205,'West Indies','West Indies','Sammy',5)
insert into Team values(206,'Afghanistan','Afghanistan','Richard',6)
insert into Team values(207,'England','England','Cook',7)


create table Match (
Match_Id         int        primary key,
Team1_Id         int        foreign key references Team(Team_Id),
Team2_Id         int        foreign key references Team(Team_Id),
Match_date       date       not null,
Venue            char(20)   not null, 
Match_Type       char(20)   not null,
Winner_Id        int        foreign key references Team(Team_Id)
)

insert into Match values (301,201,202,'2026-09-10','Delhi','ODI',201)
insert into Match values (302,203,204,'2026-09-10','Durban','T20',204)
insert into Match values (303,205,206,'2026-09-11','Kabul','T20',205)
insert into Match values (304,207,201,'2026-09-12','Bangalore','T20',201)
insert into Match values (305,202,204,'2026-09-13','Sydney','Test',202)
insert into Match values (306,205,207,'2026-09-14','London','ODI',207)
insert into Match values (307,203,206,'2026-09-15','Barbados','Test',203)
insert into Match values (308,201,207,'2026-09-15','Lords','T20',201)
insert into Match values (309,202,206,'2026-09-15','Melbourne','Test',202)



create table Player_Performance (
Performance_Id     int         primary key,
Match_Id           int         foreign key references Match(Match_Id),
Player_Id          int         foreign key references Player(Player_Id),
Runs               int         not null,
Wickets            int         not null,
Catches            int         not null
)
insert into Player_Performance values(401,301,101,170,0,1)
insert into Player_Performance values(402,302,106,40,0,0)
insert into Player_Performance values(403,303,110,0,3,0)
insert into Player_Performance values(404,304,108,108,0,2)
insert into Player_Performance values(405,305,104,36,6,1)
insert into Player_Performance values(406,306,105,125,0,3)
insert into Player_Performance values(407,307,114,78,0,1)
insert into Player_Performance values(408,308,108,82,1,1)
insert into Player_Performance values(409,309,104,32,4,3)
insert into Player_Performance values(410,301,101,170,0,1)
insert into Player_Performance values(411,301,109,4,0,0)



create table Match_Official (
Official_Id       int           primary key,
Official_Name     varchar(30)   not null,
Official_Role     char(20)      not null,
Official_Country  varchar(30)   not null,
Match_Id          int           foreign key references Match(Match_Id)
)
insert into Match_Official values(501,'Kumar Dharmasena','Umpire','India',301)
insert into Match_Official values(502,'Nitin Menon','Umpire','India',302)
insert into Match_Official values(503,'Richard Kettleborough','Umpire','England',303)
insert into Match_Official values(504,'Paul Reiffel','Umpire','Australia',304)



select Player_Name,Player_Country from Player where Role='Batsman' and Player_Age>25
select Player_Name from Player where Player_Country='India' or Player_Country='Australia'
select * from Team where Ranking<=10 and Team_Country='India'
select Match_Id,Venue,Match_Type from Match where Match_Type='T20' and Venue='Durban'
select Player_Id,Runs,Wickets from Player_Performance where Runs>50 or Wickets>2
select distinct Player_Country from Player
select distinct Match_Type from Match
select Player_Name from Player where Player_Name like 'S%' and Player_Country='India'
select count(*) as Total_Players from Player where Player_Country='India'
select max(Runs) from Player_Performance
select avg(Runs) from Player_Performance where Runs>20
select count(*) as Total_Wickets from Player_Performance
select min(Catches),max(Catches),avg(catches) from Player_Performance
select count(*) as Total_Players from Player where Player_Age>25 group by Role
select count(*) as Total_Players from Player where Role='Bowler' group by Player_Country
select p.Player_Id, p.Player_name, sum(pp.Runs) as Total_Runs from Player p 
join Player_Performance pp on p.Player_Id = pp.Player_Id where pp.runs>20 group by p.Player_Id, p.Player_Name
select Match_Id, sum(wickets) as Total_Wickets from Player_Performance where Wickets > 0 group by Match_Id
select Player_Country,count(*) Total_Player from Player 
group by Player_Country having count(*)>2
select p.Player_Id, p.Player_name, sum(pp.runs) as Total_Runs from Player p 
join Player_Performance pp on p.Player_Id = pp.Player_Id
group by p.Player_Id, p.Player_Name having sum(pp.runs)>100
select Match_ID,sum(Wickets) as Total_Wickets from Player_Performance 
group by Match_Id having sum(Wickets)>3
select p.Player_Id, p.Player_name, sum(pp.runs) as Total_Runs from Player p 
join Player_Performance pp on p.Player_Id = pp.Player_Id group by p.Player_Id, p.Player_Name 
having sum(pp.runs)>100 order by Total_Runs asc
select p.Player_Id, p.Player_name, avg(pp.runs) as Average_Runs from Player p 
join Player_Performance pp on p.Player_Id = pp.Player_Id 
group by p.Player_Id, p.Player_name having avg(pp.runs)>30 order by Average_Runs asc;
update Team set Ranking=2 where Team_Id=201
update Player set Player_Age = Player_Age+1 where Player_Age>30 and Role = 'Batsman'
update Player_Performance set Catches = Catches+1 where Wickets>2 and Catches<3
delete from Player where Player_Age>45 and Player_Country !='India'
delete from Player_Performance where Runs<5 and Wickets=0
delete from Team where Ranking>15 and Team_Country='India'
select P.Player_Name,P.Role,PP.Runs from Player P join Player_Performance PP on P.Player_Id=PP.Player_Id
select T.Team_Name,M.Match_Date,M.Venue from Team T join Match M on T.Team_ID = M.Team1_Id
select P.Player_Name,pp.Match_ID,pp.Runs,pp.Wickets from Player P 
join Player_Performance pp on P.Player_Id = pp.Player_Id where pp.Runs>50
select p.Player_Name,m.Match_Date,m.Venue,pp.runs from Player p 
join Player_Performance pp on p.Player_Id=pp.Player_Id 
join Match m on pp.Match_Id=m.Match_Id 
select P.Player_Name, M.Match_Type, M.Venue, PP.Wickets from Player P 
join Player_Performance PP on P.Player_ID = PP.Player_ID 
join Match M on PP.Match_ID = M.Match_ID where PP.Wickets > 2
select Player_Name from Player
where Player_ID in(select Player_ID from Player_Performance
where Runs > (select avg(Runs) from Player_Performance))
select P.Player_Name from Player P
join Player_Performance PP on P.Player_ID = PP.Player_ID
group by P.Player_ID, P.Player_Name having sum(PP.Runs) >
( select sum(Runs) from Player_Performance where Player_ID = 104)


 