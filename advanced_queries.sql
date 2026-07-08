-- ============================================
-- ADVANCED SQL QUERIES
-- ============================================

-- 1. Match result using CASE
SELECT
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    home_goals,
    away_goals,
    CASE
        WHEN home_goals>away_goals THEN 'Home Win'
        WHEN home_goals<away_goals THEN 'Away Win'
        ELSE 'Draw'
    END AS result
FROM premier_league_matches m
JOIN premier_league_teams t1
ON m.home_team_id=t1.team_id
JOIN premier_league_teams t2
ON m.away_team_id=t2.team_id;

-- 2. Teams with above-average player age
SELECT
    t.team_name,
    ROUND(AVG(age),2) AS average_age
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
GROUP BY t.team_name
HAVING AVG(age)>
(
SELECT AVG(age)
FROM premier_league_players
);

-- 3. Teams with more than 40 goals
SELECT
    t.team_name,
    SUM(s.goals) AS total_goals
FROM premier_league_teams t
JOIN premier_league_players p
ON t.team_id=p.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
GROUP BY t.team_name
HAVING SUM(s.goals)>40
ORDER BY total_goals DESC;

-- 4. Players scoring above their team's average
SELECT
    p.player_name,
    t.team_name,
    s.goals
FROM premier_league_players p
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
JOIN premier_league_teams t
ON p.team_id=t.team_id
WHERE s.goals>
(
SELECT AVG(s2.goals)
FROM premier_league_players p2
JOIN premier_league_player_stats s2
ON p2.player_id=s2.player_id
WHERE p2.team_id=p.team_id
);

-- 5. ROW_NUMBER ranking inside each team
SELECT
    t.team_name,
    p.player_name,
    s.goals,
    ROW_NUMBER() OVER(PARTITION BY t.team_name ORDER BY s.goals DESC) AS player_rank
FROM premier_league_players p
JOIN premier_league_teams t
ON p.team_id=t.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id;

-- 6. Top scorer in each team
SELECT
    team_name,
    player_name
FROM
(
SELECT
    t.team_name,
    p.player_name,
    RANK() OVER(PARTITION BY t.team_name ORDER BY s.goals DESC) AS rnk
FROM premier_league_players p
JOIN premier_league_teams t
ON p.team_id=t.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
) ranked
WHERE rnk=1;

-- 7. Overall player ranking
SELECT
    team_name,
    player_name,
    goals,
    assists
FROM
(
SELECT
    t.team_name,
    p.player_name,
    s.goals,
    s.assists,
    RANK() OVER(
        ORDER BY
            s.goals DESC,
            s.assists DESC,
            s.red_cards ASC,
            s.yellow_cards ASC
    ) AS rnk
FROM premier_league_players p
JOIN premier_league_teams t
ON p.team_id=t.team_id
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
) ranked
ORDER BY goals DESC;

-- 8. Goal contribution
SELECT
    p.player_name,
    s.goals,
    s.assists,
    (s.goals+s.assists) AS goal_contribution
FROM premier_league_players p
JOIN premier_league_player_stats s
ON p.player_id=s.player_id
ORDER BY goal_contribution DESC;

-- 9. Team wins, draws and losses
select
    team_name,
    sum(wins) as wins,
    sum(draws) as draws,
    sum(losses) as losses
from
(

    select
        t.team_name,
        case when m.home_goals > m.away_goals then 1 else 0 end as wins,
        case when m.home_goals = m.away_goals then 1 else 0 end as draws,
        case when m.home_goals < m.away_goals then 1 else 0 end as losses
    from premier_league_matches m
    join premier_league_teams t
        on m.home_team_id = t.team_id

    union all


    select
        t.team_name,
        case when m.home_goals < m.away_goals then 1 else 0 end as wins,
        case when m.home_goals = m.away_goals then 1 else 0 end as draws,
        case when m.home_goals > m.away_goals then 1 else 0 end as losses
    from premier_league_matches m
    join premier_league_teams t
        on m.away_team_id = t.team_id

) as results
group by team_name
order by wins desc, draws desc;