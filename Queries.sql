-- Basic select with simple where clause.
-- Select all Coaches hired after 2000
SELECT c.name, c.hiringDate
FROM FullCoach c
WHERE c.hiringDate > '2000-01-01';

-- Basic select with simple group by clause (with and without having clause).
-- How many teams does each league have?
SELECT l.name, COUNT(*) as teams
FROM Team t, League l
WHERE t.league_id = l.league_id
GROUP BY l.name;

-- What leagues have more than 10 teams?
SELECT l.name, COUNT(*) as teams
FROM Team t, League l
WHERE t.league_id = l.league_id
GROUP BY l.name
HAVING Count(*) > 10;

-- A simple join select query using cartesian product and where clause vs. a join query using on.
-- Select All Los Angeles Lakers Players
-- Cartesian Product
SELECT derived.name, derived.number, derived.position FROM 
	(SELECT Per.name, Pla.number, Pla.position, t.name as team_name
     FROM Person Per, Player Pla, Team t 
	 WHERE Per.person_id = Pla.person_id AND Pla.team_id = t.team_id) AS derived
WHERE team_name = 'Los Angeles Lakers';

-- JOIN ON
SELECT Per.name, Pla.number, Pla.position FROM Player Pla
LEFT JOIN Person Per ON Per.person_id = Pla.person_id 
LEFT JOIN Team t ON t.team_id = Pla.team_id
WHERE t.name = 'Los Angeles Lakers';

-- A few queries to demonstrate various join types on the same tables: inner vs. outer (left and right) vs. full join. Use of null values in the database to show the diferences is required.
-- Joins for players and their teams
SELECT Person.name, Player.number, Team.name
FROM Player
INNER JOIN Team ON Player.team_id = Team.team_id
INNER JOIN Person ON Person.person_id = Player.person_id;

SELECT Person.name, Player.number, Team.name
FROM Player
LEFT OUTER JOIN Team ON Player.team_id = Team.team_id
LEFT OUTER JOIN Person ON Person.person_id = Player.person_id;

SELECT Person.name, Player.number, Team.name
FROM Player
RIGHT OUTER JOIN Team ON Player.team_id = Team.team_id
JOIN Person ON Person.person_id = Player.person_id;

-- Full Join = Union, which is demonstrated later

-- A couple of examples to demonstrate correlated queries.
-- Select players who have a smaller number than at least one of their teammates
SELECT Person.name, p1.number, t.name
FROM Player p1, Team t, Person
WHERE EXISTS (
    SELECT 1
    FROM Player p2
    WHERE p2.team_id = p1.team_id
      AND p2.number > p1.number
) AND p1.team_id = t.team_id AND Person.person_id = p1.person_id;

-- Select coaches who coach at least one player older than them 
SELECT full_coach.name, full_coach.birthdate, t.name
FROM (SELECT c.*, p.name, p.birthdate FROM Coach c INNER JOIN Person p ON p.person_id = c.person_id) AS full_coach
INNER JOIN Team t ON full_coach.team_id = t.team_id
WHERE EXISTS (
    SELECT 1
    FROM (SELECT Player.*, p.name, p.birthdate FROM Player INNER JOIN Person p ON p.person_id = Player.person_id) AS full_player
    WHERE full_player.team_id = full_coach.team_id
      AND full_player.birthdate < full_coach.birthdate
);



-- One example per set operations: intersect, union, and diference vs. their equivalences without using set operations.
-- INTERSECT - Players with numbers higher than 15 and smaller than 40
SELECT p.name, p.number
FROM (SELECT Player.*, p.name FROM Player INNER JOIN Person p ON p.person_id = Player.person_id) AS p
WHERE p.number > 15
AND p.number < 40;


-- UNION - Coaches and Players who have won an award
SELECT per.name
FROM Coach c
JOIN Person per ON c.person_id = per.person_id 
JOIN Award a ON a.person_id = per.person_id
UNION
SELECT per.name
FROM Player p
JOIN Person per ON p.person_id = per.person_id 
JOIN Award a ON a.person_id = per.person_id;

-- DIFFERENCE - NBA Players who are not guards
SELECT per.name, p.position
FROM Player p
JOIN Person per ON p.person_id = per.person_id
JOIN Team t ON t.team_id = p.team_id
JOIN League l on l.league_id = t.league_id
WHERE p.position != 'Guard';


-- An example of a view that has a hard-coded criteria, by which the content of the view may change upon changing the hard-coded value (see L09 slide 24).
-- View for a Team's Players (hardcoded to Lakers)
DROP VIEW IF EXISTS TeamPlayersView;

CREATE VIEW TeamPlayersView AS
SELECT t.name AS team_name, p.name AS player_name, pl.number, pl.position, p.hometown, p.academy, p.birthdate
FROM Player pl
JOIN Person p ON pl.person_id = p.person_id
JOIN Team t ON pl.team_id = t.team_id
WHERE t.name = 'Los Angeles Lakers'; 

SELECT * FROM TeamPlayersView;


-- Two implementations of the division operator using a) a regular nested query using NOT IN and b) a correlated nested query using NOT EXISTS and EXCEPT (See [4]).
-- Regular nested query with NOT IN / Select players who have not won an award    
SELECT * 
FROM (SELECT Player.*, p.name FROM Player INNER JOIN Person p ON p.person_id = Player.person_id) AS full_player
WHERE full_player.person_id NOT IN (
    SELECT person_id
	FROM Award WHERE person_id IS NOT NULL
);

-- Correlated nested query using NOT EXISTS and EXCEPT / Same as above. 
-- Can't use Except in MySql, so we'll use NOT EXISTS
SELECT * 
FROM (SELECT Player.*, p.name FROM Player INNER JOIN Person p ON p.person_id = Player.person_id) AS full_player
WHERE NOT EXISTS 
(SELECT 1 FROM Award WHERE Award.person_id = full_player.person_id);


-- Provide queries that demonstrates the overlap and covering constraints.
-- Overlap Constraint - demonstrated by the ISA hierarchy of Person to Player and Coach having no Overlap between the two child entities
-- i.e.: No player is also a coach, and vice versa. The following query returns nothing.
SELECT Count(*) AS check_overlap
FROM Player p, Coach c 
WHERE p.person_id = c.person_id;

-- Covering constraint -- Demonstrated by there being no results when looking for Persons who are not a Player nor a coach.
-- I.E. Person is completely covered by its children. 
SELECT Count(*) AS check_uncovered 
FROM Person
WHERE Person.person_id NOT IN 
(SELECT person_id FROM Player
UNION ALL
SELECT person_id FROM Coach);