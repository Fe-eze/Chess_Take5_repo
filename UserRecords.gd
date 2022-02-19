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
	#commit_human_data_to_db()

func commit_human_data_to_db(Username, Fullname, Score):
	db.open_db()
	
	var tableName = "HumanPlayers"
	insert_new_record(tableName, Username, Fullname, Score)

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

# A function for grabbing all the profiles in a db table and listing them as an array
func list_all_users_in_db(DatabaseTable):
	db.open_db()
	db.query("SELECT \"Username\" FROM \"" + DatabaseTable + "\";")
	
	var UsernameArray = []
	for i in db.query_result:
		UsernameArray.append(i["Username"])
	
	return UsernameArray
	db.close_db()

# A function to find a user profile, this should probably be used by other functions
# When it returns false, user not found. When user is found it returns true
# This is only for finding user profiles in the HumanPlayers table, if there's any need to extend this to the AIPlayers table, then it can be edited
func find_user_in_db(Username):
	db.open_db()
	db.query("SELECT \"Username\" FROM \"HumanPlayers\" WHERE \"Username\" LIKE " + "\"" + Username + "\";")
#	print(result)
#	return result
	if db.query_result == []:
		return false
	return true
	
	db.close_db()

# A function to calculate and update the user score after a match

# *******************************************************************
# *******************************************************************
# EX_NIHILO SECTION: FUNCTIONS BELOW ARE TO ENABLE GENERATION OF DB ON FIRST GAME RUN
# TODO: work on these
# *******************************************************************
# *******************************************************************
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
	
func commitTestDataToDB():
	db.open_db()
	
	var tableName = "HumanPlayers"
	
	insert_new_record(tableName, "Lord Eddwadarsssd", "Eddard Stark", "1000")
	insert_new_record(tableName, "Littlefinger", "Petyr Baelish", "1600")
	insert_new_record(tableName, "Mykeovski", "Chukudeni Osemike", "700")
	insert_new_record(tableName, "The Pope", "Chimnachi Adeife", "700")
	insert_new_record(tableName, "Fenobus", "Fe-eze Nobuweji", "800")
	db.close_db()
