extends Node

# SAVE GAME DATABASE DESIGN

# There is a master table called 001MasterTable that stores the constants of each game and the variables that can only have one value at a time
#CREATE TABLE "0001MasterTable" (
#	"ID"	INTEGER NOT NULL UNIQUE,
#	"MatchName"	TEXT NOT NULL UNIQUE,
#	"Player1ID"	TEXT NOT NULL,
#	"Player2ID"	TEXT NOT NULL,
#	"isGameTimed"	INTEGER NOT NULL COLLATE BINARY,
#	"Time"	INTEGER NOT NULL,
#	"isGameComplete"	INTEGER NOT NULL COLLATE BINARY,
#	"GameCreatedDateTime"	TEXT NOT NULL,
#	"GameLastSavedDateTime"	TEXT NOT NULL,
#	PRIMARY KEY("ID" AUTOINCREMENT)
#);


# Each table is then linked to the Match table which stores a running history and commentary of every move taken in the game
#CREATE TABLE "Match" (
#	"ID"	INTEGER NOT NULL UNIQUE,
#	"MoveNumber"	INTEGER NOT NULL,
#	"PlayerMoved"	INTEGER NOT NULL COLLATE BINARY,
#	"TileMovedFrom"	INTEGER NOT NULL,
#	"TileMovedTo"	INTEGER NOT NULL,
#	"Commentary"	TEXT NOT NULL,
#	"TimeOnClockPlayer1"	INTEGER NOT NULL,
#	"TimeOnClockPlayer2"	INTEGER NOT NULL,
#	"isWhiteKingCheck"	INTEGER NOT NULL COLLATE BINARY,
#	"isBlackKingCheck"	INTEGER NOT NULL COLLATE BINARY,
#	"ArrayWhitePawnsMoved"	INTEGER NOT NULL,
#	"ArrayBlackPawnsMoved"	INTEGER NOT NULL,
#	PRIMARY KEY("ID" AUTOINCREMENT)
#)

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://Data/SaveGameDatabase.db"

var Player1_temp
var Player2_temp
var Player1
var Player2
var GameTime = [false, -1]

func _ready():
	db = SQLite.new()
	db.path = db_name
	
	# called to create a new table that is a unique record of a game
	# create_new_game_record("Nachi","Fe-eze",date_and_time())

func date_and_time():
	var DateTime = OS.get_datetime()
	var DateTimeString = str(DateTime["year"]) + str(DateTime["month"]) + str(DateTime["day"]) + str(DateTime["hour"]) + str(DateTime["minute"]) + str(DateTime["second"])
	
	return(DateTimeString)
	

#Returns current datetime as a dictionary of keys: year, month, day, weekday, dst (Daylight Savings Time), hour, minute, second.

# Create a new table when starting a new game
func create_new_game_record(Player1ID, Player2ID, DateTime):
	db.open_db()
	db.query("CREATE TABLE \"" + Player1ID + "vs" + Player2ID + DateTime + "\" (" +\
		"\"ID\"	INTEGER NOT NULL UNIQUE,"+\
		"\"MoveNumber\"	INTEGER NOT NULL,"+\
		"\"PlayerMoved\"	INTEGER NOT NULL COLLATE BINARY,"+\
		"\"TileMovedFrom\"	INTEGER NOT NULL,"+\
		"\"TileMovedTo\"	INTEGER NOT NULL,"+\
		"\"Commentary\"	TEXT NOT NULL,"+\
		"\"GameType\"	INTEGER NOT NULL COLLATE BINARY,"+\
		"\"TimeOnClockPlayer1\"	INTEGER NOT NULL,"+\
		"\"TimeOnClockPlayer2\"	INTEGER NOT NULL,"+\
		"\"PlayerIDPlayer1\"	INTEGER,"+\
		"\"PlayerIDPlayer2\"	INTEGER,"+\
		"PRIMARY KEY(\"ID\" AUTOINCREMENT)" +\
	");"
	)
	
	db.close_db()
