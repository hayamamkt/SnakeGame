extends Node

@export var snake_scene : PackedScene

@onready var hud: Hud = $Hud
@onready var game_over_menu: CanvasLayer = $GameOverMenu

var game_started := false

#grid variables
var cells : int = 20
var cell_size : int = 50

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#food variables
var food_pos: Vector2
var regen_food := true

var start_pos := Vector2(9, 9)
var can_move := false
var move_direction := Vector2.ZERO

func _ready():
	new_game()

func _process(_delta):
	input_snake()

#region Snake Game
func new_game():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	game_over_menu.hide()
	can_move = true
	generate_snake()
	move_food()

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

func input_snake():
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

func move_snake():
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

	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()

func check_game_started():
	can_move = false
	if game_started: return
	start_game()

func start_game():
	game_started = true
	$MoveTimer.start()

func end_game():
	game_over_menu.show()
	$MoveTimer.stop()
	game_started = false
	get_tree().paused = true

func check_out_of_bounds():
	if (
		snake_data[0].x < 0 or
		snake_data[0].x > cells - 1 or
		snake_data[0].y < 0 or
		snake_data[0].y > cells - 1
	): end_game()

func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()

func check_food_eaten():
	#if snake eats the food, add a segment and move the food
	if snake_data[0] == food_pos:
		hud.score += 1
		add_segment(old_data[-1])
		move_food()

func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Food.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	$Food.z_index = 1
	regen_food = true

#endregion


#region Signals

func _on_move_timer_timeout() -> void:
	move_snake()

func _on_game_over_menu_restart() -> void:
	new_game()

#endregion
