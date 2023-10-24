extends Node


func _ready():
	var selectionRect = get_node("GameSelection/GameSelectionRect")
	selectionRect.connect("game_selected", self, "_on_game_selected")
	load_score()
	$GameSelection/Easy/Highscore.text = "Highscore\n%d" % Global.highscore[0]
	$GameSelection/Normal/Highscore.text = "Highscore\n%d" % Global.highscore[1]
	$GameSelection/Hard/Highscore.text = "Highscore\n%d" % Global.highscore[2]


func load_score():
	var save_file = File.new()
	if not save_file.file_exists("user://highscore.save"):
		return
	save_file.open("user://highscore.save", File.READ)
	var data = parse_json(save_file.get_line())
	Global.highscore = data["highscore"]


func _on_game_selected(difficulty):
	Global.difficulty = difficulty
	get_tree().change_scene("res://Game.tscn")
