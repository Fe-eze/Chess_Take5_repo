extends WindowDialog

const HIGHEST_POSSIBLE_CHESS_SCORE = 3000

# Called when the node enters the scene tree for the first time.
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
	$FormContainer/YesButtonExactScore/NumericScoreEntry.set_max_length(4)

func _on_ChessScoreYesButton_pressed():
	# disappear the 'no' options (estimate dropdown menu) and show the 'yes' button options (exact score entry field & ScoreValidator)
	$FormContainer/NoButtonEstimateScore.visible = false
	$FormContainer/YesButtonExactScore.visible = true
	$FormContainer/ScoreValidator.visible = true

func _on_ChessScoreNoButton_pressed():
	# disappear the 'yes' button options (exact score entry field) and show the 'no' options (estimate dropdown menu)
	$FormContainer/YesButtonExactScore.visible = false
	$FormContainer/ScoreValidator.visible = false
	$FormContainer/NoButtonEstimateScore.visible = true

func _on_NumericScoreEntry_text_changed(new_text):
	var ScoreValidator = $FormContainer/ScoreValidator
	var feedback = ""
	
	if (int(new_text) != 0):
		if (int(new_text) < (HIGHEST_POSSIBLE_CHESS_SCORE + 1)):
			# chess score input is okay
			
			# TODO add score variable, to be written to database when the 'register' button is pressed
			
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
		
# Total Beginner - Trying to get into chess for the first time
# Novice - Knows a bit about chess but are still a beginner
# Lower Intermediate
# Upper Intermediate
# Competent
# Expert
# Grandmaster


# When Register button is pressed,
# ask for confirmation,
# if yes, register the user
# ask to close or register another user
func _on_RegisterButton_pressed():
	var RegistrationSummary
	var UsernameTextNode = $FormContainer/RegistrationFormContainer/UsernameTextbox
	var FullnameTextNode = $FormContainer/RegistrationFormContainer/FullnameTextbox
	var ChessScoreTextNode = $FormContainer/YesButtonExactScore/NumericScoreEntry
	var RegisterStatusNode = $FormContainer/RegisterConfirmContainer/RegistrationOutputStatus
	
	# first thing first, make the confirmation dialog visible
	$FormContainer/RegisterConfirmContainer/RegistrationOutputStatus.visible = true
	
	# Upper bounds for text length in the textboxes are already being checked and truncated in their respective ready funcitons, 
	# check the lower band ie force the user to enter something into the text box
	if len(UsernameTextNode.get_text()) < 1:
		RegistrationSummary = "Please enter a Username, Full name and Chess Score"
		RegisterStatusNode.self_modulate = Color( 1, 0, 0, 1 )

	# if all is fine and the user has entered a valid input
	# TODO, check username against one already in the database
	else:
		RegistrationSummary = "New player profile will be created. \n" + "Username: " + UsernameTextNode.get_text() + "\nFullname: " + FullnameTextNode.get_text() + "\nChess Score: " + ChessScoreTextNode.get_text() + "\nClick YES to confirm, Click NO to clear the boxes and restart the registration process"
		RegisterStatusNode.self_modulate = Color( 0, 1, 0, 1 )
		
		# disappear the register button since input is fine
		$FormContainer/RegisterButton.visible = false
		# Make YES and NO buttons visible
		$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = true
	
	RegisterStatusNode.set_text(str(RegistrationSummary))

func _on_YesButton_pressed():
	var RegisterStatusNode = $FormContainer/RegisterConfirmContainer/RegistrationOutputStatus
	
	# disappear YES and NO buttons, then ask whether you would like to register another user
	$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = false
	
	# TODO add to database
	
	# Disappear the registration form and the register button
	$FormContainer/RegistrationFormContainer.visible = false
	$FormContainer/RegisterButton.visible = false
	
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
	
	# Show the register button
	$FormContainer/RegisterButton.visible = true

func _on_YesButtonAnother_pressed():
	reset_RegisterSubMenu() # clear everything in preparation for new user registration

func _on_NoButtonQuit_pressed():
	$".".hide() # press the dialog close button
	# after hiding, the dialog box will be reset to defaults through the popup_hide() function

func _on_RegisterSubMenu_popup_hide():
	reset_RegisterSubMenu()

# ************** SNIPPET FUNCTIONS ********************
# reusable function that clears all textboxes in the form when called
func clear_textboxes():
	$FormContainer/RegistrationFormContainer/UsernameTextbox.clear()
	$FormContainer/RegistrationFormContainer/FullnameTextbox.clear()
	
func reset_RegisterSubMenu():
	clear_textboxes() # remove items from the menu
	
	# Hide all confirmatory elements
	$FormContainer/RegisterConfirmContainer/RegistrationOutputStatus.visible = false
	$FormContainer/RegisterConfirmContainer/UserConfirmation.visible = false 
	$FormContainer/RegisterConfirmContainer/AnotherUser.visible = false
	
	# Show the registration form and the register button
	$FormContainer/RegistrationFormContainer.visible = true
	$FormContainer/RegisterButton.visible = true


