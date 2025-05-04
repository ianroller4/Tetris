extends Node2D

""" Child Node Constants """
@onready var BOARD := $Background
@onready var ACTIVE := $Active
@onready var SCORE := $VBoxContainer/Score

""" Constants """
const ROTATIONS := 4 # Number of rotations
const ROWS := 20 # Height of playable area
const COLS := 10 # Width of playable area
const START_POSITION := Vector2(12, 2) # Start position of all blocks
const NEXT_POSITION := Vector2(3, 4) # Where to draw the next block

""" Block Variables"""
var blocks := Global.BLOCKS.duplicate() # Array of block types
var currentBlockType : Global.BLOCK_TYPES # Type of block in play
var nextBlockType : Global.BLOCK_TYPES # Type of block next in line
var currentPosition : Vector2 # Current position of block in play
var rotationIndex := 0 # Current rotation of the block 0 is 0, 1, is 90, etc

""" Falling Variables """
var fallTimer := 0.0 # Current time since last fall
var fallInterval := 1.0 # How long before block falls

""" Gameplay Variables """
var isGameRunning := true # Is the game is still running
var totalLinesCleared := 0 # Total number of lines cleared
var level := 1 # Current level

"""
Purpose:
	Called when entering scene
"""
func _ready():
	start_game()

"""
Purpose:
	Called every frame at a fixed rate of 60 fps
Parameters:
	delta - float, time since last frame
"""
func _physics_process(delta):
	if isGameRunning:
		block_fall(delta)

"""
Purpose:
	Handles all input
Parameters:
	event - InputEvent, a button press
"""
func _input(event):
	if isGameRunning:
		if event.is_action_pressed("left"):
			move_block(Vector2.LEFT)
		if event.is_action_pressed("right"):
			move_block(Vector2.RIGHT)
		if event.is_action_pressed("down"):
			move_block(Vector2.DOWN)
		if event.is_action_pressed("rotate_left"):
			rotate_left()
		if event.is_action_pressed("rotate_right"):
			rotate_right()
	else:
		get_tree().change_scene_to_file("res://UI/GameOver/GameOver.tscn")

""" Game Start and End """

"""
Purpose:
	Sets up and starts the game
"""
func start_game():
	Score.currentScore = 0
	currentBlockType = choose_block()
	create_block()
	nextBlockType = choose_block()
	render_next_block()

"""
Purpose:
	Check if the new tile can be spawned. If not end game by setting isGameRunning
	to false
"""
func is_game_over():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		if not is_within_bounds(START_POSITION + coor):
			isGameRunning = false

""" Block Creation """

"""
Purpose:
	Choose the type for the next block and remove type from array, duplicated 
	Global array when empty
Return:
	type - the type of block, based on BLOCK_TYPES enum
"""
func choose_block() -> Global.BLOCK_TYPES:
	var type : Global.BLOCK_TYPES
	if !blocks.is_empty():
		blocks.shuffle()
		type = blocks.pop_front()
	else:
		blocks = Global.BLOCKS.duplicate()
		blocks.shuffle()
		type = blocks.pop_front()
	
	return type

"""
Purpose:
	Sets up the position and rotation of a new block before rendering it 
"""
func create_block():
	rotationIndex = 0
	currentPosition = START_POSITION
	render_block(currentPosition)

""" Block Rendering and Clearing """

"""
Purpose:
	Draw the block to the tilemap layer Active at position pos
Parameters:
	pos - Vector2, the position to draw the block at
"""
func render_block(pos : Vector2):
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		ACTIVE.set_cell(pos + coor, Global.BLOCK_TILE_IDS[currentBlockType], Vector2(0, 0))

"""
Purpose:
	Clear the block from the tilemap layer Active at position pos
Parameters:
	pos - Vector2, the position to clear the block from
"""
func clear_block():
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		ACTIVE.erase_cell(coor + currentPosition)

"""
Purpose:
	Draw the next block to the tilemap layer Active at NEXT_POSITION
"""
func render_next_block():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		ACTIVE.set_cell(NEXT_POSITION + coor, Global.BLOCK_TILE_IDS[nextBlockType], Vector2(0, 0))

"""
Purpose:
	Clear the next block from the tilemap layer Active at NEXT_POSITION
"""
func clear_next_block():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		ACTIVE.erase_cell(NEXT_POSITION + coor)

""" Block Moving """

"""
Purpose:
	Move block down without human interaction every fallInterval seconds
Parameter:
	delta - float, time since last frame
"""
func block_fall(delta : float):
	fallTimer += delta
		
	if fallTimer >= fallInterval:
		move_block(Vector2.DOWN)
		fallTimer = 0.0

"""
Purpose:
	Move block if valid direction and check if landed
Parameter:
	direction - Vector2, direction to move block in
"""
func move_block(direction : Vector2):
	if is_valid_move(direction):
		clear_block()
		currentPosition += direction
		render_block(currentPosition)
	elif direction == Vector2.DOWN: # Move not valid when trying to move down
		land_block()
		check_rows()

"""
Purpose:
	Check if a move is valid
Parameters:
	direction - Vector2, direction to check if move is valid in
Return:
	bool - true if move is valid, false otherwise
"""
func is_valid_move(direction : Vector2) -> bool:
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		if not is_within_bounds(currentPosition + coor + direction):
			return false
	return true

"""
Purpose:
	Check if a move is within bounds or would overlap another block
Parameters:
	pos - Vector2, position of block if moved
Return:
	bool - false if out of bounds or tile is not background tile, true if 
	background tile
"""
func is_within_bounds(pos : Vector2) -> bool:
	if pos.x < 9 or pos.x > COLS + 8 or pos.y < 1 or pos.y > ROWS + 1:
		return false
	
	var id = BOARD.get_cell_source_id(pos) # Get ID of tile in tilemap
	
	return id == 10 # If 10 then tile is background tile

""" Block Rotations """

"""
Purpose:
	Rotate a block counter clockwise or left, by updating rotation index backwards
	after checking if rotation is valid
"""
func rotate_left():
	if is_valid_rotation_left():
		clear_block()
		rotationIndex = (rotationIndex - 1 + ROTATIONS) % ROTATIONS
		render_block(currentPosition)

"""
Purpose:
	Rotate a block clockwise or right, by updating rotation index forwards
	after checking if rotation is valid
"""
func rotate_right():
	if is_valid_rotation_right():
		clear_block()
		rotationIndex = (rotationIndex + 1) % ROTATIONS
		render_block(currentPosition)

"""
Purpose:
	Checks if a rotation counter clockwise or left would be valid, uses
	is_within_bounds() to check if valid
Return:
	bool - true if valid, false if not valid
"""
func is_valid_rotation_left() -> bool:
	var nextRotation = (rotationIndex - 1 + ROTATIONS) % ROTATIONS
	
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[nextRotation]:
		if not is_within_bounds(currentPosition + coor):
			return false
	
	return true

"""
Purpose:
	Checks if a rotation clockwise or right would be valid, uses
	is_within_bounds() to check if valid
Return:
	bool - true if valid, false if not valid
"""
func is_valid_rotation_right() -> bool:
	var nextRotation = (rotationIndex + 1) % ROTATIONS
	
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[nextRotation]:
		if not is_within_bounds(currentPosition + coor):
			return false
	
	return true

""" Landing Block """

"""
Purpose:
	Call all functions necessary to finish placing block and swap next block to current
	and create new next block and render it
"""
func land_block():
	set_board_cells()
	clear_block()
	Score.currentScore += 8 * level
	set_score_text()
	is_game_over()
	clear_next_block()
	currentBlockType = nextBlockType
	nextBlockType = choose_block()
	render_next_block()
	create_block()

"""
Purpose:
	Set Background tilemap cells to be where current block landed
"""
func set_board_cells():
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		BOARD.set_cell(currentPosition + coor, Global.BLOCK_TILE_IDS[currentBlockType], Vector2(0, 0))

""" Row Clearing """

"""
Purpose:
	Check for full rows after a piece has landed
"""
func check_rows():
	var rows := ROWS
	var clearCount := 0 # Count of rows cleared after piece is landed
	while rows > 0:
		var filledCells := 0
		for i in range(9, 9 + COLS): # Board area is 9 tiles over
			# 2 is added to rows since rows start 2 tiles down
			if BOARD.get_cell_source_id(Vector2(i, rows + 2)) != 10:
				filledCells += 1
		if filledCells == COLS: # If filled cells is equal to number of columns in curernt row
			shift_rows(rows) # Clear current row and shift rows down
			clearCount += 1 
			totalLinesCleared += 1 # Update total rows cleared
			update_level() # Update level
		else:
			rows -= 1
	update_score(clearCount) # Update score

"""
Purpose:
	Clears a row and shift above rows down
Parameter:
	row - int, the row to clear
"""
func shift_rows(row : int):
	var tile
	for i in range(row + 2, 2, -1): # Plus 2 since board starts 2 tiles down
		for j in range(9, 9 + COLS): # Plus 9 since board start 2 tiles over
			tile = BOARD.get_cell_source_id(Vector2(j, i - 1))
			if tile != 10: # If tile above not background match
				BOARD.set_cell(Vector2(j, i), tile, Vector2(0, 0))
			else:
				BOARD.set_cell(Vector2(j, i), tile, Vector2(1, 1))

""" Score and Level """

"""
Purpose:
	Update score based on number of lines cleared and level. Score values from 
	tetris wiki
Parameter:
	rowsCleared - int, total number of rows cleared
"""
func update_score(rowsCleared : int):
	match(rowsCleared):
		1:
			Score.currentScore += 100 * level
		2:
			Score.currentScore += 300 * level
		3:
			Score.currentScore += 500 * level
		4:
			Score.currentScore += 800 * level
		_:
			pass
	set_score_text()

"""
Purpose:
	Update score UI text
"""
func set_score_text():
	SCORE.text = str(Score.currentScore)

"""
Purpose:
	Update level. If new level update level UI text and fallInterval 
"""
func update_level():
	var newLevel = ceil(float(totalLinesCleared) / 10.0)
	if newLevel > level:
		level = newLevel
		fallInterval *= 0.9
		$VBoxContainer/Level.text = str(level)
