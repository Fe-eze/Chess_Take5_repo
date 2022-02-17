extends Control

var RegisterScene = preload("res://RegisterSubMenu.tscn")
var new_reg

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
	if (new_reg == null):
		new_reg = RegisterScene.instance()
		add_child(new_reg)
	
	new_reg.popup_centered()
	#RegisterScene.popup()
	#get_tree().change_scene("res://RegisterSubMenu.tscn")

func _on_CreditsButton_pressed():
	pass

func _on_QuitButton_pressed():
	get_tree().quit()
