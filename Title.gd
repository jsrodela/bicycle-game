extends Node


func _ready():
	var selectionRect = get_node("GameSelection/GameSelectionRect")
	selectionRect.connect("game_selected", self, "_on_game_selected")

func _on_game_selected(difficulty):
	Global.difficulty = difficulty
	get_tree().change_scene("res://Game.tscn")
