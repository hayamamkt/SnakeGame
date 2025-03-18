extends Node2D

@export var snake_scene : PackedScene

#grid variables
var cells : int = 20
var cell_size : int = 50

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

var start_pos = Vector2(9, 9)

func _ready():
	new_game()

func new_game():
	generate_snake()

func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start_pos, create tail segments vertically down
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))

func add_segment(pos: Vector2):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
