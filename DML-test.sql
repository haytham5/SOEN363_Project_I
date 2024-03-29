INSERT INTO League (league_id, name, sport, foundedDate)
VALUES
    (1, 'NBA', 'Basketball', '1946-06-06'),
    (2, 'NFL', 'American Football', '1920-08-20');

INSERT INTO Team (team_id, league_id, name, city, creationDate)
VALUES
    (1, 1, 'Los Angeles Lakers', 'Los Angeles', '1947-01-01'),
    (2, 1, 'Golden State Warriors', 'San Francisco', '1946-01-01'),
    (3, 2, 'New England Patriots', 'Foxborough', '1959-11-16');

INSERT INTO Person (person_id, name, hometown, academy, birthdate)
VALUES
    (1, 'LeBron James', 'Akron', 'St. Vincent-St. Mary High School', '1984-12-30'),
    (2, 'Stephen Curry', 'Akron', 'Davidson College', '1988-03-14'),
    (3, 'Bill Belichick', 'Nashville', 'Wesleyan University', '1952-04-16'),
    (4, 'Tom Brady', 'idk', 'idk', '2000-01-01'),
    (5, 'Anthony Davis', 'Chicago', 'Kentucky', '1993-03-11'),
    (6, 'Coachy Youngman', 'Oklahoma', 'idk', '1999-08-28');

INSERT INTO Player (player_id, person_id, team_id, number, position, joinDate)
VALUES
    (1, 1, 1, 23, 'Forward', '2018-07-01'),
    (2, 2, 2, 30, 'Guard', '2009-07-01'),
    (3, 4, 3, 12, 'Quarterback', '2001-01-01'),
    (4, 5, 1, 3, 'Center', '2019-07-01');

INSERT INTO Coach (coach_id, person_id, team_id, hiringDate)
VALUES
    (1, 3, 3, '2000-01-27'),
    (2, 6, 2, '2012-03-03');

INSERT INTO Award (award_id, league_id, name, bestowDate, person_id, team_id)
VALUES
    (1, 1, 'NBA Championship', '2023-06-15', NULL, 1),
    (2, 2, 'Super Bowl', '2023-02-05', NULL, 2),
    (3, 2, 'Super Bowl', '2023-02-05', 4, NULL),
    (4, 2, 'Super Bowl', '2023-02-05', 3, NULL);

INSERT INTO PlayoffGame (playoff_id, year, hometeam_id, guestTeam_id, round, score, winner_id)
VALUES
    (1, 2023, 1, 2, 'Finals', '4-2', 1),
    (2, 2023, 3, 2, 'Super Bowl', '10-23', 3);