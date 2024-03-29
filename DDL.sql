DROP TABLE IF EXISTS PlayoffGame;
DROP TABLE IF EXISTS Award;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Coach;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS League;

CREATE TABLE League (
	league_id INT NOT NULL,
  	name VARCHAR(255) NOT NULL,
  	sport VARCHAR(255) NOT NULL,
  	foundedDate DATE NOT NULL,
  	PRIMARY KEY(league_id),
  	UNIQUE(sport)
);

CREATE TABLE Team (
	team_id INT NOT NULL,
  	league_id INT NOT NULL,
  	name VARCHAR(255) NOT NULL,
  	city VARCHAR(255) NOT NULL,
  	creationDate DATE NOT NULL,
  	PRIMARY KEY(team_id),
  	UNIQUE(name),
  	FOREIGN KEY(league_id) REFERENCES League(league_id) ON DELETE CASCADE
);
  
CREATE TABLE Person (
	person_id INT NOT NULL,
  	name VARCHAR(255) NOT NULL,
    hometown VARCHAR(255) NOT NULL,
  	academy VARCHAR(255) NOT NULL,
  	birthdate DATE NOT NULL,
  	PRIMARY KEY(person_id)
);

CREATE TABLE Player (
    player_id INT NOT NULL,
    person_id INT NOT NULL,
    team_id INT NOT NULL,
    number INT NOT NULL,
    position VARCHAR(255) NOT NULL,
    joinDate DATE NOT NULL,
    PRIMARY KEY(player_id),
    FOREIGN KEY(person_id) REFERENCES Person(person_id) ON DELETE CASCADE,
    FOREIGN KEY(team_id) REFERENCES Team(team_id) ON DELETE CASCADE,
    CONSTRAINT unique_number UNIQUE (team_id, number)
);
 
CREATE TABLE Coach (
    coach_id INT NOT NULL,
    person_id INT NOT NULL,
    team_id INT NOT NULL,
    hiringDate DATE NOT NULL,
    PRIMARY KEY(coach_id),
    FOREIGN KEY(person_id) REFERENCES Person(person_id) ON DELETE CASCADE,
    FOREIGN KEY(team_id) REFERENCES Team(team_id) ON DELETE CASCADE,
    UNIQUE (team_id)
);
 
CREATE TABLE Award (
  	award_id INT NOT NULL,
  	league_id INT NOT NULL,
  	name VARCHAR(255) NOT NULL,
  	bestowDate DATE NOT NULL,
    person_id INT,
    team_id INT,
  	PRIMARY KEY(award_id),
  	FOREIGN KEY(league_id) REFERENCES League(league_id) ON DELETE CASCADE,
  	CONSTRAINT awardee
        CHECK ((person_id IS NULL AND team_id IS NOT NULL) OR (person_id IS NOT NULL AND team_id IS NULL))
);
  
CREATE TABLE PlayoffGame (
	playoff_id INT NOT NULL,
  	year INT NOT NULL,
  	hometeam_id INT NOT NULL,
  	guestTeam_id INT NOT NULL,
  	round VARCHAR(255) NOT NULL,
  	score VARCHAR(255) NOT NULL,
  	winner_id INT NOT NULL,
  	PRIMARY KEY(playoff_id),
  	FOREIGN KEY(hometeam_id) REFERENCES Team(team_id) ON DELETE CASCADE,
	FOREIGN KEY(guestTeam_id) REFERENCES Team(team_id) ON DELETE CASCADE,
  	FOREIGN KEY(winner_id) REFERENCES Team(team_id) ON DELETE CASCADE
);

DROP VIEW IF EXISTS FullPlayer;
DROP VIEW IF EXISTS FullCoach;

CREATE VIEW FullPlayer AS
SELECT pl.player_id, pl.person_id, pl.number, pl.position, pl.joinDate,
       p.name, p.hometown, p.academy, p.birthdate, Team.name as team_name, Team.city
FROM Player pl
JOIN Person p ON pl.person_id = p.person_id
JOIN Team ON pl.team_id = Team.team_id;

CREATE VIEW FullCoach AS
SELECT c.coach_id, c.person_id, c.hiringDate,
       p.name, p.hometown, p.academy, p.birthdate, Team.name as team_name, Team.city
FROM Coach c
JOIN Person p ON c.person_id = p.person_id
JOIN Team on c.team_id = Team.team_id;
