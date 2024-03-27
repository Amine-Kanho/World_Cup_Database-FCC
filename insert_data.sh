#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get new team_id for unique winner name
    if [[ -z $($PSQL "SELECT name FROM teams WHERE name='$WINNER'") ]]
    then
      #insert team_winner tale
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    #get new team_id for unique opponent name
    if [[ -z $($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'") ]]
    then
      #insert team_opponent 
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

    #get winner_id and opponent_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    #get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$WIN_ID AND opponent_id=$OPP_ID")
    if [[ -z $GAME_ID ]]
    then
      #insert game
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO 
        games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
        VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOALS, $OPP_GOALS)
        ")
    fi
  fi
done