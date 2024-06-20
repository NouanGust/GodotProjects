extends Node

@onready var pause_menu = $PauseMenu
@onready var resume_btn = $PauseMenu/MenuContainer/ResumeBtn


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu.visible = true
		pause_menu.get_tree().paused = true
		resume_btn.grab_focus()

func _on_resume_btn_pressed():
	pause_menu.get_tree().paused = false
	pause_menu.visible = false


func _on_quit_btn_pressed():
	get_tree().quit()
