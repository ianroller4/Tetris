extends Control

"""
Purpose:
	Called when entering scene
"""
func _ready():
	$Score.text = str(Score.currentScore)
	$Score.hide()
	$VerticalMenu.hide()
	$Pointer.hide()
	update_high_score()
	SaveLoad.save()

"""
Purpose:
	Upon game over check if score is in top 5 and if so adjust score accordingly by 
	shifting lower scores down.
"""
func update_high_score():
	if Score.currentScore > Score.first: # Score is new top score
		Score.fifth = Score.fourth
		Score.fourth = Score.third
		Score.third = Score.second
		Score.second = Score.first
		Score.first = Score.currentScore
		
	elif Score.currentScore > Score.second: # Score is new second
		Score.fifth = Score.fourth
		Score.fourth = Score.third
		Score.third = Score.second
		Score.second = Score.currentScore
		
	elif Score.currentScore > Score.third: # Score is new third
		Score.fifth = Score.fourth
		Score.fourth = Score.third
		Score.third = Score.currentScore
		
	elif Score.currentScore > Score.fourth: # Score is new fourth
		Score.fifth = Score.fourth
		Score.fourth = Score.currentScore
		
	elif Score.currentScore > Score.fifth: # Score is new fifth
		Score.fifth = Score.currentScore


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
		"Controls":
			# Change scene to controls
			get_tree().change_scene_to_file("res://UI/Controls/Controls.tscn")
		"MainMenu":
			# Change scene to main menu
			get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")

"""
Purpose:
	On timer timeout, show menu items and configure focus to allow selection of items 
"""
func _on_timer_timeout():
	$Timer.stop()
	$VerticalMenu.show()
	$Pointer.show()
	$VerticalMenu.configure_focus()

"""
Purpose:
	On timer timeout, show score
"""
func _on_timer_2_timeout():
	$Timer2.stop()
	$Score.show()
