extends Control

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
			# Change scene to high scores
			get_tree().change_scene_to_file("res://UI/High Score/HighScore.tscn")
		"MainMenu":
			# Change scene to main menu
			get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")
		"Quit":
			# Quit the program
			get_tree().quit()
