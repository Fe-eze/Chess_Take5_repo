extends Control

const MAX_SECONDS_IN_A_MINUTE = 60

# Declare member variables here.
# TODO create function that does player types/ player labels generation
var PlayerTypes = ["Human", "AI"]
var PlayerLabels = []

var HumanPlayerDatabase = UserRecords.list_all_users_in_db("HumanPlayers")
var AIPlayerDatabase = UserRecords.list_all_users_in_db("AIPlayers")
var isGameTimed = false
var TurnTime = [0, 0]
var ValidationMessage = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ValidateButton.connect("pressed",self,"ReportListItem")
	# TODO a value being returned here, use it for something

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

# when the timer toggle is pressed, make timer settings container visible
# else, keep it invisible
# note that it is invisible by default
func _on_TimerToggle_toggled(button_pressed):
	if button_pressed == true:
		$VBoxContainer/TimerSettingsContainer.visible = true
		isGameTimed = true
	else:
		$VBoxContainer/TimerSettingsContainer.visible = false
		isGameTimed = false
		TurnTime = [0, 0]

# Conduct validation on the mm and ss text inputs.
# Throw an error code if either of them isn't an int
# or if the ss section exceeds 60
func _on_MinuteSetting_text_changed(new_text):
	var MinuteValidation = ""
	var MMVaidationLabel = $VBoxContainer/TimerSettingsContainer/MMValidationLabel #grab this to avoid needless repitition
	
	if int(new_text) != 0:
		# input is okay, save the mm setting
		# success flag, display a green status message
		TurnTime[0] = new_text
		MinuteValidation = "mm field Okay!"
		MMVaidationLabel.self_modulate = Color( 0, 1, 0, 1 )
		MMVaidationLabel.set_text(str(MinuteValidation))
	else:
		# alert user to correct this
		# failure flag, display a red status message
		MinuteValidation = "mm must be an integer!"
		MMVaidationLabel.self_modulate = Color( 1, 0, 0, 1 )
		MMVaidationLabel.set_text(str(MinuteValidation))

func _on_SecondSetting_text_changed(new_text):
	var SecondValidation = ""
	var SSVaidationLabel = $VBoxContainer/TimerSettingsContainer/SSValidationLabel #grab this to avoid needless repitition
	if (int(new_text) != 0):
		if (int(new_text) < MAX_SECONDS_IN_A_MINUTE):
			# input is okay, save the ss setting
			# success flag, display a green status message
			TurnTime[1] = new_text
			SecondValidation = "ss field Okay!"
			SSVaidationLabel.self_modulate = Color( 0, 1, 0, 1 )
			SSVaidationLabel.set_text(str(SecondValidation))
		else:
			# failure flag, display a red status message
			SecondValidation = "ss must be b/w 0 & 59!"
			SSVaidationLabel.self_modulate = Color( 1, 0, 0, 1 )
			SSVaidationLabel.set_text(str(SecondValidation))
	else:
		# failure flag, display a red status message
		SecondValidation = "ss must be an integer!"
		SSVaidationLabel.self_modulate = Color( 1, 0, 0, 1 )
		SSVaidationLabel.set_text(str(SecondValidation))

# Load the Four game options into the screen
func _on_PlayerOptions_ready():
	# TODO remove nested for loop
	for i in range(PlayerTypes.size()):
		for j in range(PlayerTypes.size()):
			PlayerLabels.append([PlayerTypes[i], PlayerTypes[j]]) # put into this array so it can be called easily later
			$VBoxContainer/PlayerOptions.add_item(PlayerTypes[i] + " v " + PlayerTypes[j],null,true) # display p1 vs p2 as text to the menu screen
	$VBoxContainer/PlayerOptions.select(0,true)

# when player has selected a game mode, 
# show a dropdown of available human and ai players in side by side columns TODO change implementation, make it a dropdown instead of a button scroll list
# first option should be register new user (which will open up the user registration dialog
# list should be searchable
func _on_PlayerOptions_item_selected(index):
	# If Human v AI is selected, the two textboxes that show up will load as:
	# Select Player1 "Human"			Select Player 2 (AI)
	# ** list of human players **		** list of AI players **
	# ** list is scrollable, and each element of the list is a button containing the name of a player registered in the database **
	# ** end of list **
	
	# Display the menu labels for Player 1 and Player 2 (as selected by the user)
	$VBoxContainer/PlayerSelectorContainer/Player1SelectorLabel.set_text("SELECT PLAYER 1 [" + str(PlayerLabels[index][0]) + "]")
	$VBoxContainer/PlayerSelectorContainer/Player2SelectorLabel.set_text("SELECT PLAYER 2 [" + str(PlayerLabels[index][1]) + "]")
	
	# Start by grabbing the location of the Player1 & Player2 nodes, to avoid repitition
	var Player1Dropdown = $VBoxContainer/PlayerSelectorContainer/Player1ScrollContainer/Player1SelectorDropdown
	var Player2Dropdown = $VBoxContainer/PlayerSelectorContainer/Player2ScrollContainer/Player2SelectorDropdown
	
	# Since it is live, delete any database that may have been generated in a previous click
	delete_children(Player1Dropdown)
	delete_children(Player2Dropdown)
	
	# Check what player 1 is set as (Human or AI?) and load the corresponding database
	if PlayerLabels[index][0] == "Human":
		display_database_names(Player1Dropdown, HumanPlayerDatabase)
	else:
		display_database_names(Player1Dropdown, AIPlayerDatabase)
	
	# check what player 2 is set as, and load the corresponding database
	if PlayerLabels[index][1] == "Human":
		display_database_names(Player2Dropdown, HumanPlayerDatabase)
	else:
		display_database_names(Player2Dropdown, AIPlayerDatabase)
		
# Helper function to help delete children as needed
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Helper function to loop through the player or AI database name column
# and spit out the relevant list
func display_database_names(Player, Database):
	for i in Database:
		var button = Button.new()
		button.text = i
		#button.connect(pressed, self, 
		Player.add_child(button)
