extends Node

""" Save Variables """
const SAVE_PATH := "user://TetrisSave.json" # Save file path
var saveData := {"first" : 0, "second" : 0, "third" : 0, "fourth" : 0, "fifth" : 0} # Save data

"""
Purpose:
	Create a file at the save path and store the save data by writing it to the file
"""
func create_save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(saveData)
	file.close()

"""
Purpose:
	Save the score data to the save data variable and write save data to the file
	at the save path
"""
func save():
	saveData["first"] = Score.first
	saveData["second"] = Score.second
	saveData["third"] = Score.third
	saveData["fourth"] = Score.fourth
	saveData["fifth"] = Score.fifth
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(saveData)
	file.close()

"""
Purpose:
	Open file at save path and read save data into correct variables
"""
func load_save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	Score.first = data["first"]
	Score.second = data["second"]
	Score.third = data["third"]
	Score.fourth = data["fourth"]
	Score.fifth = data["fifth"]
