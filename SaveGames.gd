extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://Data/SaveGameDatabase.db"

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
