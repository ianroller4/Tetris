extends Node2D

@onready var BOARD := $Background
@onready var ACTIVE := $Active
@onready var SCORE := $VBoxContainer/Score

const ROTATIONS := 4

const ROWS := 20
const COLS := 10

var blocks := Global.BLOCKS.duplicate()

var currentBlockType : Global.BLOCK_TYPES
var nextBlockType : Global.BLOCK_TYPES

const START_POSITION := Vector2(12, 2)
const NEXT_POSITION := Vector2(3, 4)
var currentPosition : Vector2

var rotationIndex := 0

var fallTimer := 0.0
var fallInterval := 1.0
var fastFallMult := 10.0

var isGameRunning := true

var totalLinesCleared := 0
var level := 1

func _ready():
	start_game()

func _physics_process(delta):
	if isGameRunning:
		var currentFallInterval = fallInterval
		if Input.is_action_just_pressed("down"):
			currentFallInterval /= fastFallMult
		fallTimer += delta
		if fallTimer >= currentFallInterval:
			move_block(Vector2.DOWN)
			fallTimer = 0.0

func _input(event):
	if isGameRunning:
		if event.is_action_pressed("left"):
			move_block(Vector2.LEFT)
		if event.is_action_pressed("right"):
			move_block(Vector2.RIGHT)
		if event.is_action_pressed("rotate_left"):
			rotate_left()
		if event.is_action_pressed("rotate_right"):
			rotate_right()
	else:
		get_tree().change_scene_to_file("res://UI/GameOver/GameOver.tscn")

func start_game():
	Score.currentScore = 0
	currentBlockType = choose_block()
	create_block()
	nextBlockType = choose_block()
	render_next_block()

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

func create_block():
	rotationIndex = 0
	currentPosition = START_POSITION
	render_block(currentPosition)

func render_block(pos : Vector2):
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		ACTIVE.set_cell(pos + coor, Global.BLOCK_TILE_IDS[currentBlockType], Vector2(0, 0))

func clear_block():
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		ACTIVE.erase_cell(coor + currentPosition)

func render_next_block():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		ACTIVE.set_cell(NEXT_POSITION + coor, Global.BLOCK_TILE_IDS[nextBlockType], Vector2(0, 0))

func clear_next_block():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		ACTIVE.erase_cell(NEXT_POSITION + coor)

func move_block(direction : Vector2):
	if is_valid_move(direction):
		clear_block()
		currentPosition += direction
		render_block(currentPosition)
	elif direction == Vector2.DOWN:
		land_block()
		check_rows()

func is_valid_move(direction : Vector2) -> bool:
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		if not is_within_bounds(currentPosition + coor + direction):
			return false
	return true

func is_within_bounds(pos : Vector2) -> bool:
	if pos.x < 9 or pos.x > COLS + 8 or pos.y < 1 or pos.y > ROWS + 1:
		return false
	
	var id = BOARD.get_cell_source_id(pos)
	
	return id == 10

func land_block():
	set_board_cells()
	clear_block()
	is_game_over()
	clear_next_block()
	currentBlockType = nextBlockType
	nextBlockType = choose_block()
	render_next_block()
	create_block()

func set_board_cells():
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[rotationIndex]:
		BOARD.set_cell(currentPosition + coor, Global.BLOCK_TILE_IDS[currentBlockType], Vector2(0, 0))

func rotate_left():
	if is_valid_rotation_left():
		clear_block()
		rotationIndex = (rotationIndex - 1 + ROTATIONS) % ROTATIONS
		render_block(currentPosition)

func rotate_right():
	if is_valid_rotation_right():
		clear_block()
		rotationIndex = (rotationIndex + 1) % ROTATIONS
		render_block(currentPosition)

func is_valid_rotation_left() -> bool:
	var nextRotation = (rotationIndex - 1 + ROTATIONS) % ROTATIONS
	
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[nextRotation]:
		if not is_within_bounds(currentPosition + coor):
			return false
	
	return true

func is_valid_rotation_right() -> bool:
	var nextRotation = (rotationIndex + 1) % ROTATIONS
	
	var tileCoordinates = Global.BLOCK_DATA[currentBlockType]
	for coor in tileCoordinates[nextRotation]:
		if not is_within_bounds(currentPosition + coor):
			return false
	
	return true

func check_rows():
	var rows := ROWS
	var clearCount := 0
	while rows > 0:
		var filledCells := 0
		for i in range(9, 9 + COLS):
			if BOARD.get_cell_source_id(Vector2(i, rows + 2)) != 10:
				filledCells += 1
		if filledCells == COLS:
			shift_rows(rows)
			clearCount += 1
			totalLinesCleared += 1
			update_level()
		else:
			rows -= 1
	update_score(clearCount)

func update_level():
	var newLevel = ceil(float(totalLinesCleared) / 10.0)
	if newLevel > level:
		level = newLevel
		fallInterval *= 0.9
		$VBoxContainer/Level.text = str(level)

func shift_rows(row : int):
	var tile
	for i in range(row + 2, 2, -1):
		for j in range(9, 9 + COLS):
			tile = BOARD.get_cell_source_id(Vector2(j, i - 1))
			if tile != 10:
				BOARD.set_cell(Vector2(j, i), tile, Vector2(0, 0))
			else:
				BOARD.set_cell(Vector2(j, i), tile, Vector2(1, 1))

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
	SCORE.text = str(Score.currentScore)

func is_game_over():
	var tileCoordinates = Global.BLOCK_DATA[nextBlockType]
	for coor in tileCoordinates[0]:
		if not is_within_bounds(START_POSITION + coor):
			isGameRunning = false
