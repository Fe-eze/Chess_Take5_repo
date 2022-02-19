extends ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".set_title("Confirm New Game Settings") # Make text "Register New User" the dialog window title
	#show()
	popup_centered() # Make the window alive and center it
	
	# Then show the new game summary rich text box
	# New Game Summary
	# xxx [Player1] vs xxx [Player2]
	# Untimed Game/ Timed Game [45mins per player]
	# Click [YES] if you would like to proceed or [ACNCEL] if you would like to change something
	var GameTime
	if SaveGames.GameTime[0] == false:
		GameTime = "Untimed Game"
	else:
		GameTime = "Timed Game [" + String(SaveGames.GameTime[1]/60) + "mins per turn]"
	
	var SummaryText = "New Game Summary\n" +\
	SaveGames.Player1_temp + "[PLAYER 1] vs. " + SaveGames.Player2_temp + "[PLAYER 2]\n" +\
	"\n" + GameTime +\
	"\nClick [YES] if you would like to proceed or [CANCEL] if you would like to change something"
	
	$SummaryBox.self_modulate = Color( 0, 1, 0, 1 ) # Treen color
	$SummaryBox.set_text(str(SummaryText)) # put all text on the confirmatory screen
	
	# on YES, create new game record in the db and change scene to chessboard
	# the new game is created and the chessboard scene is loaded with the new game settings populated in
	# on CANCEL, go back to new game box (remove the popup)
