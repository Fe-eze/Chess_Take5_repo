extends Control

const MAX_SECONDS_IN_A_MINUTE = 60

# Declare member variables here. Examples:
var ListContents = ["Human v Human", "Human v AI", "AI v AI"]
var HumanPlayerDatabase = ["Nachi", "Deni", "Fe-eze"]# TODO change and implement proper database
var isGameTimed = false
var TurnTime = [0, 0]
var Player1 = ""
var Player2 = ""
var ValidationMessage = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for ItemID in range(ListContents.size()):
		$VBoxContainer/PlayerOptions.add_item(ListContents[ItemID],null,true)

	$VBoxContainer/PlayerOptions.select(0,true)

	$VBoxContainer/ValidateButton.connect("pressed",self,"ReportListItem")
	

func ReportListItem():
	#var ItemNo = $VBoxContainer/PlayerOptions.get_selected_items

	#The output ItemNo is a list of selected items.  Use this to select
	#The matching component from the associated array, ItemListContent.
 
	#$VBoxContainer/TimerSettingsContainer/OutputLabel.set_text(str(ValidationMessage))
	pass

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
	if int(new_text) != 0:
		# input is okay, save the mm setting
		# success flag, display a green status message
		TurnTime[0] = new_text
		MinuteValidation = "mm field Okay!"
		$VBoxContainer/TimerSettingsContainer/MMValidationLabel.self_modulate = Color( 0, 1, 0, 1 )
		$VBoxContainer/TimerSettingsContainer/MMValidationLabel.set_text(str(MinuteValidation))
	else:
		# alert user to correct this
		# failure flag, display a red status message
		MinuteValidation = "mm must be an integer!"
		$VBoxContainer/TimerSettingsContainer/MMValidationLabel.self_modulate = Color( 1, 0, 0, 1 )
		$VBoxContainer/TimerSettingsContainer/MMValidationLabel.set_text(str(MinuteValidation))

func _on_SecondSetting_text_changed(new_text):
	var SecondValidation = ""
	if (int(new_text) != 0):
		if (int(new_text) < MAX_SECONDS_IN_A_MINUTE):
			# input is okay, save the ss setting
			# success flag, display a green status message
			TurnTime[1] = new_text
			SecondValidation = "ss field Okay!"
			$VBoxContainer/TimerSettingsContainer/SSValidationLabel.self_modulate = Color( 0, 1, 0, 1 )
			$VBoxContainer/TimerSettingsContainer/SSValidationLabel.set_text(str(SecondValidation))
		else:
			# failure flag, display a red status message
			SecondValidation = "ss must be b/w 0 & 59!"
			$VBoxContainer/TimerSettingsContainer/SSValidationLabel.self_modulate = Color( 1, 0, 0, 1 )
			$VBoxContainer/TimerSettingsContainer/SSValidationLabel.set_text(str(SecondValidation))
	else:
		SecondValidation = "ss must be an integer!"
		$VBoxContainer/TimerSettingsContainer/SSValidationLabel.self_modulate = Color( 1, 0, 0, 1 )
		$VBoxContainer/TimerSettingsContainer/SSValidationLabel.set_text(str(SecondValidation))


# TODO implement this
# when player has selected a game mode, 
# show a dropdown of available human and ai players in side by side columns
# first option should be register new user (which will open up the user registration dialog
# list should be searchable
func _on_PlayerOptions_item_selected(index):
	# If Human v human is selected, the two textboxes that show up will load as
	# Player1 "Human"
	# Player2 "Human"
	if index == ListContents[0]:
		pass
	elif index == ListContents[1]:
		pass
	elif index == ListContents[2]:
		pass


