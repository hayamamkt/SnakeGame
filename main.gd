extends Node

@export var snake_scene : PackedScene

var game_started := false

#grid variables
var cells : int = 20
var cell_size : int = 50

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

var start_pos := Vector2(9, 9)
var can_move := false
var move_direction := Vector2.ZERO

func _ready():
	new_game()

func _process(_delta):
	move_snake()

#region Snake Game
func new_game():
	can_move = true
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

func move_snake():
	if not can_move: return

	if Input.is_action_just_pressed("move_down") and move_direction != Vector2.UP:
		move_direction = Vector2.DOWN
		check_game_started()
	if Input.is_action_just_pressed("move_up") and move_direction != Vector2.DOWN:
		move_direction = Vector2.UP
		check_game_started()
	if Input.is_action_just_pressed("move_left") and move_direction != Vector2.RIGHT:
		move_direction = Vector2.LEFT
		check_game_started()
	if Input.is_action_just_pressed("move_right") and move_direction != Vector2.LEFT:
		move_direction = Vector2.RIGHT
		check_game_started()

func check_game_started():
	can_move = false
	if game_started: return
	start_game()

func start_game():
	game_started = true
	$MoveTimer.start()

#endregion


func _on_move_timer_timeout() -> void:
	#allow snake movement
	can_move = true
	#use the snake's previous position to move the segments
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		#move all the segments along by one
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
