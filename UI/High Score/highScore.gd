extends Control

""" Score Labels """
@onready var FIRST := $Scores/One
@onready var SECOND := $Scores/Two
@onready var THIRD := $Scores/Three
@onready var FOURTH := $Scores/Four
@onready var FIFTH := $Scores/Five

"""
Purpose:
	Called when entering scene
"""
func _ready():
	FIRST.text = str(Score.first)
	SECOND.text = str(Score.second)
	THIRD.text = str(Score.third)
	FOURTH.text = str(Score.fourth)
	FIFTH.text = str(Score.fifth)

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
		"Controls":
			# Change scene to high scores
			get_tree().change_scene_to_file("res://UI/Controls/Controls.tscn")
		"MainMenu":
			# Change scene to main menu
			get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")
		"Quit":
			# Quit the program
			get_tree().quit()
