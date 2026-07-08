CREATE TABLE premier_league_teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(100) NOT null
);



CREATE TABLE premier_league_matches (
    match_id SERIAL PRIMARY KEY,
    round_matches INT NOT NULL CHECK (round_matches BETWEEN 1 AND 38),

    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,

    home_goals INT NOT NULL DEFAULT 0 CHECK (home_goals >= 0),
    away_goals INT NOT NULL DEFAULT 0 CHECK (away_goals >= 0),
    home_or_away varchar(10) check(home_or_away in ('Home', 'Away')),

    CONSTRAINT fk_home_team
        FOREIGN KEY (home_team_id)
        REFERENCES premier_league_teams(team_id),

    CONSTRAINT fk_away_team
        FOREIGN KEY (away_team_id)
        REFERENCES premier_league_teams(team_id),

    CONSTRAINT different_teams
        CHECK (home_team_id <> away_team_id)
);



CREATE TABLE premier_league_players (
    player_id SERIAL PRIMARY KEY,

    player_name VARCHAR(100) NOT NULL,

    age INT NOT NULL
        CHECK (age BETWEEN 16 AND 45),

    team_id INT NOT NULL,

    position VARCHAR(20) NOT NULL
        CHECK (position IN ('GK', 'DF', 'MF', 'FW')),

    matches_played INT NOT NULL DEFAULT 0
        CHECK (matches_played >= 0),

    starts INT NOT NULL DEFAULT 0
        CHECK (starts >= 0),

    minutes INT NOT NULL DEFAULT 0
        CHECK (minutes >= 0),

    CONSTRAINT fk_player_team
        FOREIGN KEY (team_id)
        REFERENCES premier_league_teams(team_id)
);
 

 

CREATE TABLE premier_league_player_stats (
    player_id INT PRIMARY KEY,
    goals INT DEFAULT 0 CHECK (goals >= 0),
    own_goals INT DEFAULT 0 CHECK (own_goals >= 0),
    assists INT DEFAULT 0 CHECK (assists >= 0),
    yellow_cards INT DEFAULT 0 CHECK (yellow_cards >= 0),
    red_cards INT DEFAULT 0 CHECK (red_cards >= 0),

    CONSTRAINT fk_player
        FOREIGN KEY (player_id)
        REFERENCES premier_league_players(player_id)
);