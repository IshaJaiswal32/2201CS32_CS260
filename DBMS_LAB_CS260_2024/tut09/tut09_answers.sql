-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
CREATE TABLE player (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT,
    dob DATE,
    batting_hand TEXT,
    bowling_skill TEXT,
    country_name TEXT
);

 CREATE TABLE team (
    team_id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE match (
    match_id INTEGER PRIMARY KEY,
    team_1 INTEGER,
    team_2 INTEGER,
    match_date DATE,
    season_id INTEGER CHECK (season_id BETWEEN 1 AND 9),
    venue TEXT,
    toss_winner INTEGER,
    toss_decision TEXT,
    win_type TEXT,
    win_margin INTEGER,
    outcome_type TEXT,
    match_winner INTEGER,
    man_of_the_match INTEGER,
    FOREIGN KEY (team_1) REFERENCES team(team_id),
    FOREIGN KEY (team_2) REFERENCES team(team_id),
    FOREIGN KEY (toss_winner) REFERENCES team(team_id),
    FOREIGN KEY (match_winner) REFERENCES team(team_id),
    FOREIGN KEY (man_of_the_match) REFERENCES player(player_id)
);


CREATE TABLE player_match (
    match_id INTEGER,
    player_id INTEGER,
    role TEXT,
    team_id INTEGER,
    FOREIGN KEY (match_id) REFERENCES match(match_id),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_id) REFERENCES team(team_id),
    PRIMARY KEY (match_id, player_id)
);

CREATE TABLE ball_by_ball (
    match_id INTEGER,
    over_id INTEGER CHECK (over_id BETWEEN 1 AND 20),
    ball_id INTEGER CHECK (ball_id BETWEEN 1 AND 9),
    innings_no INTEGER CHECK (innings_no BETWEEN 1 AND 4),
    team_batting INTEGER,
    team_bowling INTEGER,
    striker_batting_position INTEGER,
    striker INTEGER,
    non_striker INTEGER,
    bowler INTEGER,
    PRIMARY KEY (match_id, over_id, ball_id, innings_no),
    FOREIGN KEY (match_id) REFERENCES match(match_id),
    FOREIGN KEY (team_batting) REFERENCES team(team_id),
    FOREIGN KEY (team_bowling) REFERENCES team(team_id),
    FOREIGN KEY (striker) REFERENCES player(player_id),
    FOREIGN KEY (non_striker) REFERENCES player(player_id),
    FOREIGN KEY (bowler) REFERENCES player(player_id)
);

CREATE TABLE batsman_scored (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    runs_scored INTEGER,
    innings_no INTEGER,
    PRIMARY KEY (match_id, over_id, ball_id, innings_no),
    FOREIGN KEY (match_id) REFERENCES match(match_id)
);


CREATE TABLE wicket_taken (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    player_out INTEGER,
    kind_out TEXT,
    innings_no INTEGER,
    PRIMARY KEY (match_id, over_id, ball_id, innings_no),
    FOREIGN KEY (match_id) REFERENCES match(match_id),
    FOREIGN KEY (player_out) REFERENCES players(player_id),
);

CREATE TABLE extraRuns (
    match_id INTEGER,
    over_id INTEGER,
    ball_id INTEGER,
    extra_type TEXT,
    extra_runs INTEGER,
    innings_no INTEGER,
    PRIMARY KEY (match_id, over_id, ball_id, innings_no),
    FOREIGN KEY (match_id) REFERENCES match(match_id)
);

--Query 1
SELECT player_name
FROM player
WHERE batting_hand = 'Left-hand bat' AND country_name = 'England'
ORDER BY player_name;

--Query 2
SELECT player_name, FLOOR(DATEDIFF('2018-12-02', dob) / 365.25) AS player_age
FROM player
WHERE bowling_skill = 'Legbreak googly' AND FLOOR(DATEDIFF('2018-12-02', dob) / 365.25) >= 28
ORDER BY player_age DESC, player_name;

--Query 3
SELECT match_id, toss_winner
FROM match
WHERE toss_decision = 'bat'
ORDER BY match_id;

--Query 4
SELECT over_id, runs_scored
FROM batsman_scored
WHERE match_id = 335987 AND runs_scored <= 7
ORDER BY runs_scored DESC, over_id;

--Query 5
SELECT DISTINCT player_name
FROM player AS p
JOIN wicket_taken AS w ON p.player_id = w.player_out
WHERE kind_out = 'bowled'
ORDER BY player_name;

--Query 6
SELECT m.match_id, t1.name AS team_1, t2.name AS team_2, tw.name AS winning_team, m.win_margin
FROM match AS m
JOIN team AS t1 ON m.team_1 = t1.team_id
JOIN team AS t2 ON m.team_2 = t2.team_id
JOIN team AS tw ON m.match_winner = tw.team_id
WHERE m.win_margin >= 60
ORDER BY m.win_margin ASC, m.match_id;

--Query 7
SELECT player_name
FROM player
WHERE batting_hand = 'Left-hand bat' AND FLOOR(DATEDIFF('2018-12-02', dob) / 365.25) < 30
ORDER BY player_name;

--Query 8
SELECT b.match_id, SUM(b.runs_scored + e.extra_runs) AS total_runs
FROM batsman_scored AS b
JOIN extra_runs AS e ON b.match_id = e.match_id AND b.over_id = e.over_id AND b.ball_id = e.ball_id AND b.innings_no = e.innings_no
GROUP BY b.match_id
ORDER BY b.match_id;

--Query 9
SELECT b.match_id, b.over_id, SUM(b.runs_scored + e.extra_runs) AS total_runs, p.player_name AS bowler_name
FROM batsman_scored AS b
JOIN ball_by_ball AS bb ON b.match_id = bb.match_id AND b.over_id = bb.over_id AND b.ball_id = bb.ball_id AND b.innings_no = bb.innings_no
JOIN player AS p ON bb.bowler = p.player_id
JOIN extra_runs AS e ON b.match_id = e.match_id AND b.over_id = e.over_id AND b.ball_id = e.ball_id AND b.innings_no = e.innings_no
GROUP BY b.match_id, b.over_id, p.player_name
HAVING SUM(b.runs_scored + e.extra_runs) = (
    SELECT MAX(total_runs)
    FROM (
        SELECT SUM(runs_scored + extra_runs) AS total_runs
        FROM batsman_scored AS bs
        JOIN extra_runs AS er ON bs.match_id = er.match_id AND bs.over_id = er.over_id AND bs.ball_id = er.ball_id AND bs.innings_no = er.innings_no
        WHERE bs.match_id = b.match_id
        GROUP BY bs.over_id
    ) AS subquery
)
ORDER BY b.match_id, b.over_id;


--Query 10
SELECT p.player_name, COUNT(*) AS run_out_count
FROM player AS p
JOIN wicket_taken AS w ON p.player_id = w.player_out
WHERE w.kind_out = 'run out'
GROUP BY p.player_name
ORDER BY run_out_count DESC, p.player_name;

--Query 11
SELECT w.kind_out, COUNT(*) AS out_count
FROM wicket_taken AS w
GROUP BY w.kind_out
ORDER BY out_count DESC, w.kind_out;

--Query 12
SELECT t.name, COUNT(*) AS man_of_the_match_count
FROM team AS t
JOIN match AS m ON m.man_of_the_match IS NOT NULL AND t.team_id = m.man_of_the_match
GROUP BY t.name
ORDER BY t.name;

--Query 13
SELECT m.venue
FROM match AS m
JOIN extra_runs AS e ON m.match_id = e.match_id
WHERE e.extra_type = 'wide'
GROUP BY m.venue
HAVING COUNT(e.extra_type) = (
    SELECT MAX(wide_count)
    FROM (
        SELECT COUNT(*) AS wide_count
        FROM extra_runs
        WHERE extra_type = 'wides'
        GROUP BY match_id
    ) AS subquery
)
ORDER BY m.venue
LIMIT 1;

--Query 14
SELECT m.venue
FROM match AS m
WHERE m.match_winner = m.team_bowling
GROUP BY m.venue
ORDER BY COUNT(*) DESC, m.venue;

--Query 15
SELECT p.player_name, ROUND(SUM(bb.runs_scored + er.extra_runs) / COUNT(w.player_out), 3) AS average
FROM player AS p
JOIN ball_by_ball AS bb ON p.player_id = bb.bowler
JOIN extra_runs AS er ON bb.match_id = er.match_id AND bb.over_id = er.over_id AND bb.ball_id = er.ball_id AND bb.innings_no = er.innings_no
JOIN wicket_taken AS w ON bb.match_id = w.match_id AND bb.over_id = w.over_id AND bb.ball_id = w.ball_id AND bb.innings_no = w.innings_no
WHERE w.player_out IS NOT NULL
GROUP BY p.player_name
HAVING COUNT(w.player_out) > 0
ORDER BY average ASC, p.player_name;

--Query 16
SELECT p.player_name, t.name
FROM player_match AS pm
JOIN player AS p ON pm.player_id = p.player_id
JOIN team AS t ON pm.team_id = t.team_id
JOIN match AS m ON pm.match_id = m.match_id
WHERE pm.role = 'CaptainKeeper' AND m.match_winner = pm.team_id
ORDER BY p.player_name;

--Query 17
SELECT p.player_name, SUM(b.runs_scored)
FROM batsman_scored AS b
JOIN player AS p ON b.player_id = p.player_id
GROUP BY b.match_id, b.player_id
HAVING SUM(b.runs_scored) >= 50
ORDER BY SUM(b.runs_scored) DESC, p.player_name;

--Query 18
SELECT DISTINCT p.player_name
FROM batsman_scored AS b
JOIN player AS p ON b.player_id = p.player_id
JOIN match AS m ON b.match_id = m.match_id
GROUP BY b.match_id, b.player_id
HAVING SUM(b.runs_scored) >= 100 AND m.match_winner <> m.team_batting
ORDER BY p.player_name;

--Query 19
SELECT m.match_id, m.venue
FROM match AS m
JOIN team AS t ON m.match_winner <> t.team_id
WHERE t.name = 'Kolkata Knight Riders' AND (m.team_1 = t.team_id OR m.team_2 = t.team_id)
ORDER BY m.match_id;

--Query 20
SELECT p.player_name, ROUND(SUM(b.runs_scored) / COUNT(DISTINCT b.match_id), 3) AS batting_average
FROM batsman_scored AS b
JOIN player AS p ON b.player_id = p.player_id
JOIN match AS m ON b.match_id = m.match_id
WHERE m.season_id = 5
GROUP BY b.player_id
ORDER BY batting_average DESC, p.player_name
LIMIT 10;
