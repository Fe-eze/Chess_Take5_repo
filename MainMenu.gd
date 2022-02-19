extends Control

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
	# TODO a value being returned here, use it for something

func _on_LoadGameButton_pressed():
	pass

func _on_LearnChessButton_pressed():
	pass

func _on_OptionsButton_pressed():
	var new_reg = ConstantsAndDifficulty.new_reg
	var RegisterScene = ConstantsAndDifficulty.RegisterScene
	
	if (new_reg == null):
		new_reg = RegisterScene.instance()
		add_child(new_reg)
	
	new_reg.popup_centered()

func _on_CreditsButton_pressed():
	pass

func _on_QuitButton_pressed():
	get_tree().quit()
