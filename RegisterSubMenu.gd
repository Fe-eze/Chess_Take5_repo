# Notes to future self
# Please don't hate me, I know the code is messy
#
# Some rules:
# Don't hide ChessScoreContainer or RegistrationConfirmContainer but hide or show the subelements themselves
# The ChessScore Container works thus:
# the YesButtonExactScore and NoButtonEstimate generate mutually exclusive boxes that occupy the same part of the screen, hence they have to be hidden and shown individually
# In this way, both containers are more administrative than functional
# Know this and know peace

extends WindowDialog

# ********************** VARIABLES **********************************
# *******************************************************************
# *******************************************************************
var Username = ""
var Fullname = ""
var ChessScore = 0

# ********************** READY FUNCTIONS ****************************
# *******************************************************************
# *******************************************************************
func _ready():
	$".".set_title("Register New User") # Make text "Register New User" the dialog window title
	#show()
	popup_centered() # Make the window alive and center it

# limit username text length
func _on_UsernameTextbox_ready():
	$FormContainer/RegistrationFormContainer/UsernameTextbox.set_max_length(32)

# limit full name text length
func _on_FullnameTextbox_ready():
	$FormContainer/RegistrationFormContainer/FullnameTextbox.set_max_length(64)

# limit chess score text length
func _on_NumericScoreEntry_ready():
	$FormContainer/ChessScoreContainer/YesButtonExactScore/NumericScoreEntry.set_max_length(4)

# When the diffiulty list is ready, populate the list with difficulty levels from the Constants in the constants file [ConstantsAndDifficulty.gd]
func _on_DifficultyList_ready():
	var DifficultyListNode = $FormContainer/ChessScoreContainer/NoButtonEstimateScore/DifficultyList
	for i in ConstantsAndDifficulty.DIFFICULTY_LEVELS.keys():
		DifficultyListNode.add_item(i)
	# TODO Add text of difficulty levels in $FormContainer/ScoreVaidator
	
# *******************************************************************
# *******************************************************************
# ACTIONS WHEN BUTTON A BUTTON IS PRESSED WHEN ASKED FOR CHESS SCORE [YES] OR [NO]
# *******************************************************************
# *******************************************************************
func _on_ChessScoreYesButton_pressed():
	# disappear the 'no' options (estimate dropdown menu) and show the 'yes' button options (exact score entry field & ScoreValidator)
	$FormContainer/ChessScoreContainer/NoButtonEstimateScore.visible = false
	$FormContainer/ChessScoreContainer/YesButtonExactScore.visible = true
	$FormContainer/ChessScoreContainer/ScoreValidator.visible = true

func _on_ChessScoreNoButton_pressed():
	# disappear the 'yes' button options (exact score entry field) and show the 'no' options (estimate dropdown menu)
	$FormContainer/ChessScoreContainer/YesButtonExactScore.visible = false
	$FormContainer/ChessScoreContainer/ScoreValidator.visible = false
	$FormContainer/ChessScoreContainer/NoButtonEstimateScore.visible = true

# *******************************************************************
# *******************************************************************
# ACTIONS WHEN CHESS SCORE IS ENTERED BY THE USER OR THE SCORE DROPDOWN IS INTERACTED WITH
# *******************************************************************
# *******************************************************************
func _on_NumericScoreEntry_text_changed(new_text):
	var ScoreValidator = $FormContainer/ChessScoreContainer/ScoreValidator
	var feedback = ""
	
	# TODO implement strict int casting, don't allow any alphabet in a designated integer field
	if (int(new_text) != 0):
		if (int(new_text) < (ConstantsAndDifficulty.HIGHEST_POSSIBLE_CHESS_SCORE + 1)):
			# chess score input is okay
			
			# TODO to be written to database when the 'register' button is pressed
			ChessScore = generate_chess_score(new_text)
			
			# success flag, display a green status message
			# TODO bonus, give feedback based on score (ie, nice! you seem to be an intermediate player etc.
			feedback = "Chess Score Okay!"
			ScoreValidator.self_modulate = Color( 0, 1, 0, 1 )
			ScoreValidator.set_text(str(feedback))
		else:
			# failure flag, display a red status message
			feedback = "Chess score must be b/w 0 & 3000!"
			ScoreValidator.self_modulate = Color( 1, 0, 0, 1 )
			ScoreValidator.set_text(str(feedback))
	else:
		# failure flag, display a red status message
		feedback = "Chess score must be an integer!"
		ScoreValidator.self_modulate = Color( 1, 0, 0, 1 )
		ScoreValidator.set_text(str(feedback))

# When user picks a difficulty level (meaning they're not sure about their score), generate a score
func _on_DifficultyList_item_selected(index):
	var DifficultyListNode = $FormContainer/ChessScoreContainer/NoButtonEstimateScore/DifficultyList
	var SelectedDifficulty = DifficultyListNode.get_item_text(index)
	
	ChessScore = generate_chess_score(SelectedDifficulty)
	# TODO correct minor bug in Difficulty Level selection. When a profile has been registered fully and the user tries to register a new profile, the difficulty level dropdown shows whatever was last selected. Need to find a way to reset this!
	
# *******************************************************************
# *******************************************************************
# ACTIONS WHEN THE REGISTER BUTTON IS PRESSED (PRESUMABLY ALL IS WELL THEN WE ADVANCE, OR ELSE, THE USER GOES BACK TO ENTER EARLIER FIELDS
# *******************************************************************
# *******************************************************************

# When Register button is pressed,
# ask for confirmation,
# if yes, register the user
# ask to close or register another user
func _on_RegisterButton_pressed():
	var RegistrationSummary
	var UsernameTextNode = $FormContainer/RegistrationFormContainer/UsernameTextbox
	var FullnameTextNode = $FormContainer/RegistrationFormContainer/FullnameTextbox
	var RegisterStatusNode = $FormContainer/RegisterConfirmContainer/RegistrationOutputStatus
	
	# first thing first, make the confirmation dialog visible
	$FormContainer/RegisterConfirmContainer/RegistrationOutputStatus.visible = true
	
	# Upper bounds for text length in the textboxes are already being checked and truncated in their respective ready funcitons, so check the lower bound i.e. force the user to enter something into the text box
	# Also check that the ChessScore variable has been changed (ie user either entered a chess score manually, or through the dropdown list)
	if (len(UsernameTextNode.get_text()) < 1) or (ChessScore == 0):
		RegistrationSummary = "Please enter a Username, Full name and Chess Score"
		RegisterStatusNode.self_modulate = Color( 1, 0, 0, 1 )

	# if all is fine and the user has entered a valid input
	# TODO, check username against one already in the database
	else:
		RegistrationSummary = "A new player profile will be created. \n" + "Username: " + UsernameTextNode.get_text() + "\nFullname: " + FullnameTextNode.get_text() + "\nChess Score: " + String(ChessScore) + "\nClick YES to confirm, Click NO to clear the boxes and restart the registration process"
		RegisterStatusNode.self_modulate = Color( 0, 1, 0, 1 )
		
		# Disappear the register button, form and chess Score container elements since input is fine
		$FormContainer/RegistrationFormContainer.visible = false
		$FormContainer/ChessScoreContainer/YesButtonExactScore.visible = false
		$FormContainer/ChessScoreContainer/NoButtonEstimateScore.visible = false
		$FormContainer/ChessScoreContainer/ScoreValidator.visible = false
		$FormContainer/RegisterButton.visible = false
	
		# Make YES and NO buttons visible
		$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = true
	
	RegisterStatusNode.set_text(str(RegistrationSummary))

# *******************************************************************
# *******************************************************************
# ACTIONS AFTER REGISTER BUTTON ALLOWS US TO PROCEED, PRESS [YES] OR [NO] BUTTON TO CONFIRM OR CANCEL
# *******************************************************************
# *******************************************************************
func _on_YesButton_pressed():
	var RegisterStatusNode = $FormContainer/RegisterConfirmContainer/RegistrationOutputStatus
	
	# disappear YES and NO buttons, then ask whether you would like to register another user
	$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = false
	
	# TODO add to database
	
	# Confirm user successfuly registered
	var RegistrationSummary = "User Registered Succesfully!\nWould you like to register another user?"
	RegisterStatusNode.self_modulate = Color( 0, 1, 0, 1 )
	RegisterStatusNode.set_text(str(RegistrationSummary))

	# show second yes and no buttons
	$FormContainer/RegisterConfirmContainer/AnotherUser.visible = true
	# hand over to the pressed signals of the two buttons ->
	# if yes is pressed, disappear all things after the register button
	# if no is pressed, quit the dialog
	
func _on_NoButton_pressed():
	clear_textboxes()
	
	# Disappear confirmatory dialogs
	$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = false # disappear YES and NO buttons
	$FormContainer/RegisterConfirmContainer/RegistrationOutputStatus.visible = false # disappear status box
	
	# Show the register button and the registration form
	$FormContainer/RegistrationFormContainer.visible = true
	$FormContainer/RegisterButton.visible = true

# *******************************************************************
# *******************************************************************
# ACTIONS WHEN USER IS REGISTERED SUCCESSFULLY, WE CAN EITHER REGISTER ANOTHER USER OR EXIT THE REGISTRATION FORM
# *******************************************************************
# *******************************************************************
func _on_YesButtonAnother_pressed():
	reset_RegisterSubMenu() # clear everything in preparation for new user registration

func _on_NoButtonQuit_pressed():
	$".".hide() # press the dialog close button
	# after hiding, the dialog box will be reset to defaults through the popup_hide() function

# *******************************************************************
# *******************************************************************
# ACTIONS WHEN THE FORM IS EXITED (EITHER FORM THE WINDOW'S [X] BUTTON OR THE [NOBUTTONQUIT]
# *******************************************************************
# *******************************************************************
func _on_RegisterSubMenu_popup_hide():
	reset_RegisterSubMenu()


# *******************************************************************
# *******************************************************************
# SNIPPET/ HELPER FUNCTIONS
# *******************************************************************
# *******************************************************************

# reusable function that clears all textboxes in the form when called
func clear_textboxes():
	$FormContainer/RegistrationFormContainer/UsernameTextbox.clear()
	$FormContainer/RegistrationFormContainer/FullnameTextbox.clear()
	$FormContainer/ChessScoreContainer/YesButtonExactScore/NumericScoreEntry.clear()
	
# Clear the whole form and reset its components in preparation for calling it again
func reset_RegisterSubMenu():
	clear_textboxes() # remove items from the menu
	
	# Hide all confirmatory elements
	$FormContainer/ChessScoreContainer/YesButtonExactScore.visible = false
	$FormContainer/ChessScoreContainer/NoButtonEstimateScore.visible = false
	$FormContainer/RegisterConfirmContainer/RegistrationOutputStatus.visible = false
	$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = false 
	$FormContainer/RegisterConfirmContainer/AnotherUser.visible = false
	
	# Show the registration form and the register button
	$FormContainer/RegistrationFormContainer.visible = true
	$FormContainer/RegisterButton.visible = true

# function to generate chess scores
func generate_chess_score(key):
	if key in ConstantsAndDifficulty.DIFFICULTY_LEVELS.keys():
		var score = ConstantsAndDifficulty.DIFFICULTY_LEVELS[key]["DefaultScore"]
		return score
	return int(key)

# *******************************************************************
# *******************************************************************
# END
# *******************************************************************
# *******************************************************************
