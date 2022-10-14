extends Node

var difficulty:int = 0
var playing:bool = false


func _ready():
	OS.window_fullscreen = false
	OS.window_maximized = true


func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_released("exit_game"):
		get_tree().quit()
