extends CanvasLayer
class_name Hud

@onready var score_label: Label = %Score


var score := 0:
	set(v):
		score = v
		update_score()

func update_score():
	score_label.text = str(score	)
