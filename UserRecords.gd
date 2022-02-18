# DATABASE SHENANIGANS
# USER RECORDS DATABASE

extends Node

# TODO If it does not exist, create a fresh db file with the create statement loading an empty human player table and some ai players
# or else load the db into the scene

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://Data/UserRecordsDatabase.db"

func _ready():
	db = SQLite.new()
	db.path = db_name
#	if does_db_exist() == false:
#		createHumanPlayersDB()
	commitDataToDB()

func does_db_exist():
	db.open_db()
	
	db.query("SELECT name FROM sqlite_master WHERE type='table' AND name='HumanPlayers';")
	db.close_db()
	return db.query_result
	

func createHumanPlayersDB():
	db.open_db()
	
	db.query("CREATE TABLE \"HumanPlayers\" ("			+\
	"\"ID\"	INTEGER NOT NULL UNIQUE,"					+\
	"\"Username\"	INTEGER NOT NULL UNIQUE,"				+\
	"\"Fullname\"	INTEGER NOT NULL,"						+\
	"\"NumMatchesWon\"	INTEGER NOT NULL DEFAULT 0," 	+\
	"\"NumMatchesDrawn\"	INTEGER NOT NULL DEFAULT 0," 	+\
	"\"NumMatchesLost\"	INTEGER NOT NULL DEFAULT 0," 	+\
	"\"Score\"	INTEGER NOT NULL,"						+\
	"PRIMARY KEY(\"ID\" AUTOINCREMENT)"					+\
	");")

	db.close_db()

func commitDataToDB():
	db.open_db()
	
	var tableName = "HumanPlayers"
	
	insert_new_record(tableName, "Lord Eddwadarsssd", "Eddard Stark", "1000")
	insert_new_record(tableName, "Littlefinger", "Petyr Baelish", "1600")
	insert_new_record(tableName, "Mykeovski", "Chukudeni Osemike", "700")
	insert_new_record(tableName, "The Pope", "Chimnachi Adeife", "700")
	insert_new_record(tableName, "Fenobus", "Fe-eze Nobuweji", "800")
	db.close_db()
	
func insert_new_record(tableName, Username, Fullname, Score):
	db.query("INSERT INTO " + \
	tableName + \
	"(\"Username\", \"Fullname\", \"Score\") VALUES(" + "\"" + \
	Username + \
	"\"" + ", " + "\"" + \
	Fullname + "\"" + ", " + \
	Score + \
	");")

# A function to read the database
func read_user_records(db):
	pass
	
# A function for displaying all the user profiles in the db

# A function to write user records to file

# When creating a new user profile, there should be some sort of function that allows the user to select their perceived rank and uses that to generate a chess score something like 
# Total Beginner - Trying to get into chess for the first time
# Novice - Knows a bit about chess but are still a beginner
# Lower Intermediate
# Upper Intermediate
# Competent
# Expert
# Grandmaster

# A function to find a user profile, this should probably be used by other functions

# A function to calculate and update the user score after a match
# If userscore is not present and total matches < 5 dont update
