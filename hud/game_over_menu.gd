extends CanvasLayer

signal restart

func _on_button_restart_pressed() -> void:
	restart.emit()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
