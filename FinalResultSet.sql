-- Query to use database portfolio
Use portfolio;

-- Query to make player id a primary key
Alter table tennisplayers add constraint primary key (player_id);

-- Query to make winner id an integer
Alter table tennismatches modify winner_id int;

-- Query to make loser id an integer
Alter table tennismatches modify loser_id int;

-- Creating tables with matches won and lost for each player
create table matcheswon (player_id int, player_name varchar (50), wins int);
create table matcheslost (player_id int, player_name varchar (50), losses int);

-- Inserting data into matches won table
INSERT INTO matcheswon (player_id, player_name, wins)
SELECT winner_id, winner_name, count(*) as total_matches_won from tennismatches
group by winner_id, winner_name
order by winner_id;

-- Inserting data into matches lost table
INSERT INTO matcheslost (player_id, player_name, losses)
Select loser_id, loser_name, count(*) as total_matches_lost from tennismatches
group by loser_id, loser_name
order by loser_id; 

-- Query for requried data including case statements, multiple functions to calculate percentages and averages, and using joins to combine player data from the 4 tables
Select players.player_id, matches.winner_name,players.country, matcheswon.wins as career_wins, matcheslost.losses as career_losses,
 (wins + losses) as total_matches_played,
ROUND((wins/(wins +losses)) *100) as win_percentage, SUM(w_ace) + SUM(l_ace) as total_aces,
ROUND(AVG(w_ace + l_ace)) as avg_ace_per_match, SUM(w_df) + SUM(l_df) as total_doublefaults, ROUND(AVG(w_df + l_df)) as avg_doublefaults_per_match,
SUM(w_bpSaved) + SUM(l_bpSaved) as total_breakpoints_saved,
ROUND(( SUM(w_bpsaved) +SUM(l_bpsaved)) / (SUM(w_bpfaced) + SUM(l_bpfaced) ) * 100) as Percentage_of_SavedBreakPoints,
ROUND(( SUM(w_1stwon) +SUM(l_1stwon)) / (SUM(w_1stin) + SUM(l_1stin) ) *100) as Percentage_of_1stServePointsWon,
CASE
	WHEN winner_name IN ('Novak Djokovic', 'Rafael Nadal', 'Andy Murray', 'Roger Federer') THEN 'Big 4'
    ELSE 'Outside Big 4'
END as Category
from tennisplayers players left join tennismatches matches
on players.player_id = matches.winner_id
inner join matcheswon
on players.player_id = matcheswon.player_id
inner join matcheslost
on players.player_id = matcheslost.player_id
group by players.player_id, matches.winner_name, wins, losses
order by career_wins desc;

-- End of document