-- ============================================
-- BASIC SQL QUERIES
-- ============================================

-- 1. List all teams alphabetically
SELECT team_name
FROM premier_league_teams
ORDER BY team_name;

-- 2. Players older than 25
SELECT player_id, player_name
FROM premier_league_players
WHERE age > 25;

-- 3. All forwards
SELECT player_id, player_name
FROM premier_league_players
WHERE position = 'FW';

-- 4. Players with more than 2000 minutes
SELECT player_id, player_name
FROM premier_league_players
WHERE minutes > 2000;

-- 5. Home team wins
SELECT
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    home_goals,
    away_goals
FROM premier_league_matches m
JOIN premier_league_teams t1
    ON m.home_team_id = t1.team_id
JOIN premier_league_teams t2
    ON m.away_team_id = t2.team_id
WHERE home_goals > away_goals;

-- 6. Draw matches
SELECT
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    home_goals,
    away_goals
FROM premier_league_matches m
JOIN premier_league_teams t1
    ON m.home_team_id = t1.team_id
JOIN premier_league_teams t2
    ON m.away_team_id = t2.team_id
WHERE home_goals = away_goals;

-- 7. Number of teams
SELECT COUNT(*) AS total_teams
FROM premier_league_teams;

-- 8. Players by position
SELECT
    position,
    COUNT(*) AS players_count
FROM premier_league_players
GROUP BY position;

-- 9. Oldest player
SELECT *
FROM premier_league_players
ORDER BY age DESC
LIMIT 1;

-- 10. Youngest player
SELECT *
FROM premier_league_players
ORDER BY age
LIMIT 1;

-- 11. Number of players in each team
SELECT
    t.team_name,
    COUNT(p.player_id) AS players_count
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
GROUP BY t.team_name
ORDER BY players_count DESC;

-- 12. Average age by team
SELECT
    t.team_name,
    ROUND(AVG(age),2) AS average_age
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
GROUP BY t.team_name
ORDER BY average_age DESC;

-- 13. Total minutes by team
SELECT
    t.team_name,
    SUM(minutes) AS total_minutes
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
GROUP BY t.team_name
ORDER BY total_minutes DESC;

-- 14. Players with their teams
SELECT
    t.team_name,
    p.player_name
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
ORDER BY t.team_name;

-- 15. Total goals by team
SELECT
    t.team_name,
    SUM(s.goals) AS total_goals
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
GROUP BY t.team_name
ORDER BY total_goals DESC;

-- 16. Total assists by team
SELECT
    t.team_name,
    SUM(s.assists) AS total_assists
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
GROUP BY t.team_name
ORDER BY total_assists DESC;

-- 17. Team with most goals
SELECT
    t.team_name,
    SUM(s.goals) AS total_goals
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
GROUP BY t.team_name
ORDER BY total_goals DESC
LIMIT 1;

-- 18. Top 10 scorers
SELECT
    p.player_name,
    s.goals
FROM premier_league_players p
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
ORDER BY s.goals DESC
LIMIT 10;

-- 19. Players with most yellow cards
SELECT
    p.player_name,
    s.yellow_cards
FROM premier_league_players p
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
ORDER BY s.yellow_cards DESC;

-- 20. Defenders with most goals
SELECT
    p.player_name,
    s.goals
FROM premier_league_players p
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
WHERE position='DF'
ORDER BY s.goals DESC;

-- 21. Under-21 players with most minutes
SELECT
    player_name,
    minutes
FROM premier_league_players
WHERE age<21
ORDER BY minutes DESC;

-- 22. Players who never started
SELECT player_name
FROM premier_league_players
WHERE starts=0;

-- 23. Players who started every match they played
SELECT player_name
FROM premier_league_players
WHERE starts=matches_played;