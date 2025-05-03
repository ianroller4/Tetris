extends Node

""" Types of Blocks """
enum BLOCK_TYPES {
	I,
	J,
	L,
	O,
	S,
	T,
	Z
}

""" Block Tile ID """
const BLOCK_TILE_IDS = {
	BLOCK_TYPES.I: 1,
	BLOCK_TYPES.J: 0,
	BLOCK_TYPES.L: 4,
	BLOCK_TYPES.O: 2,
	BLOCK_TYPES.S: 3,
	BLOCK_TYPES.T: 5,
	BLOCK_TYPES.Z: 6
}

""" Array of Block Types """
const BLOCKS = [
	BLOCK_TYPES.I,
	BLOCK_TYPES.J,
	BLOCK_TYPES.L,
	BLOCK_TYPES.O,
	BLOCK_TYPES.S,
	BLOCK_TYPES.T,
	BLOCK_TYPES.Z
]

""" Dictionary for Block Cell Data"""
const BLOCK_DATA = {
	BLOCK_TYPES.I: I,
	BLOCK_TYPES.J: J,
	BLOCK_TYPES.L: L,
	BLOCK_TYPES.O: O,
	BLOCK_TYPES.S: S,
	BLOCK_TYPES.T: T,
	BLOCK_TYPES.Z: Z
}

""" Block Cell Data """
const I := [
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)], # 0 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(1, 3)], # 90 degrees
	[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)], # 180 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(1, 3)]  # 270 degrees
]

const J := [
	[Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)], # 0 degrees
	[Vector2(1, 0), Vector2(2, 0), Vector2(1, 1), Vector2(1, 2)], # 90 degrees
	[Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(2, 2)], # 180 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(0, 2), Vector2(1, 2)]  # 270 degrees
]

const L := [
	[Vector2(2, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)], # 0 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2)], # 90 degrees
	[Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(0, 2)], # 180 degrees
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(1, 2)]  # 270 degrees
]

const O := [
	[Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)], # 0 degrees
	[Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)], # 90 degrees
	[Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)], # 180 degrees
	[Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]  # 270 degrees
]

const S := [
	[Vector2(1, 0), Vector2(2, 0), Vector2(0, 1), Vector2(1, 1)], # 0 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(2, 1), Vector2(2, 2)], # 90 degrees
	[Vector2(1, 1), Vector2(2, 1), Vector2(0, 2), Vector2(1, 2)], # 180 degrees
	[Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2)]  # 270 degrees
]
 
const T := [
	[Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)], # 0 degrees
	[Vector2(1, 0), Vector2(1, 1), Vector2(2, 1), Vector2(1, 2)], # 90 degrees
	[Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(1, 2)], # 180 degrees
	[Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2)]  # 270 degrees
]

const Z := [
	[Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)], # 0 degrees
	[Vector2(2, 0), Vector2(1, 1), Vector2(2, 1), Vector2(1, 2)], # 90 degrees
	[Vector2(0, 1), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2)], # 180 degrees
	[Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 2)]  # 270 degrees
]
