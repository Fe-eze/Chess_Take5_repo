extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer2/VBoxContainer/ContinueButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ContinueButton_pressed():
	pass 
	
func _on_NewGameButton_pressed():
	get_tree().change_scene("res://NewGameSubMenu.tscn")

func _on_LoadGameButton_pressed():
	pass

func _on_LearnChessButton_pressed():
	pass

func _on_OptionsButton_pressed():
	get_tree().change_scene("res://RegisterSubMenu.tscn")

func _on_CreditsButton_pressed():
	pass

func _on_QuitButton_pressed():
	get_tree().quit()



