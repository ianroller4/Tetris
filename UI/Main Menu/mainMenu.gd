extends Control

"""
Purpose:
	Called when entering scene
"""
func _ready():
	if not FileAccess.file_exists(SaveLoad.SAVE_PATH): # Check if save file exists
		SaveLoad.create_save() # Create save if it does not exist
	else:
		SaveLoad.load_save() # Load save if it does exist

"""
Purpose:
	Change scene based on selected menu item
Parameters:
	The control item that was focused on when an option was selected.
"""
func _on_menu_item_chosen(item):
	match(item.name):
		"Play":
			# Change scene to game
			get_tree().change_scene_to_file("res://Game Board/GameBoard.tscn")
		"HighScore":
			# Change scene to high score
			get_tree().change_scene_to_file("res://UI/High Score/HighScore.tscn")
		"Controls":
			# Change scene to controls
			get_tree().change_scene_to_file("res://UI/Controls/Controls.tscn")
		"Quit":
			# Quit the program
			get_tree().quit()
