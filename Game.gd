extends Node

export(PackedScene) var obstacle1_scene
export(PackedScene) var obstacle2_scene

onready var player = get_node("Player")

const gravity:float = 6.0
const power:float = 6.0
const vx:float = 200.0
const max_vy:float = 200.0
const min_vy:float = - 200.0
const sensitivity:float = 1.5

var score:int = 0
var vy:float = 0
var line_spawn:bool = true

var line_score: Array = [1, 3, 5, 10, 20, 30, 40, 50, 60] # 이 점수에 도달하면 선이 나옴


func _ready():
	randomize()
	Global.level = 0
	$MessageLabel.text = "READY"
	$MessageLabel.show()
	$SceneTimer.wait_time = 1
	$SceneTimer.start()
	$ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	$ScoreLabel.hide()
	$LevelLabel.hide()
	player.position = Vector2(360, 540)


func _process(delta):
	
	if Global.playing:
		
		if Input.is_action_pressed("move"):
			# Accelerate upwards
			if (vy > min_vy):
				vy -= min(1, sensitivity * (vy - min_vy) / (-min_vy)) * power
		else:
			# Accelerate downwards
			if (vy < max_vy):
				vy += min(1, sensitivity * (max_vy - vy) / max_vy) * gravity

		player.rotation = atan2(vy, vx)

		player.position.y += vy * delta
		
		
		if score in line_score and line_spawn == true:
			line_spawn = false
			
			var line = obstacle2_scene.instance()
	
			var line_spawn_location = get_node("LinePath/LineSpawnLocation")
			
			line.position = line_spawn_location.position
			line.rotation = PI
			
			var line_velocity = Vector2(700, 0)
			line.linear_velocity = line_velocity.rotated(line.rotation)

			
			add_child(line)
			
		if score-1 in line_score:
			line_spawn = true			
		
		$LevelLabel.text = "level: %d" % Global.level # 레벨 표시하는 부분


func _on_SceneTimer_timeout():
	if $MessageLabel.text == "READY":
		$MessageLabel.text = "GO!"
		$SceneTimer.wait_time = 0.5
		$SceneTimer.start()
	elif $MessageLabel.text == "GO!":
		$MessageLabel.text = ""
		$MessageLabel.hide()
		Global.playing = true
		$ScoreTimer.start()
		$ScoreLabel.text = "Score: %d" % score
		$ScoreLabel.show()
		$LevelLabel.text = "level: %d" % Global.level
		$LevelLabel.show()
		$ObstacleTimer.start()
	else:
		# Game over
		get_tree().change_scene("res://Title.tscn")


func _on_ScoreTimer_timeout():
	score += 1
	$ScoreLabel.text = "Score: %d" % score


func _on_ObstacleTimer_timeout():
	$ObstacleTimer.wait_time = rand_range(1.4 - Global.difficulty * 0.2, 5.0 - Global.difficulty)
	$ObstacleTimer.start()

	var obstacle = obstacle1_scene.instance()

	var spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation")
	spawn_location.offset = randi()

	var direction = atan3(player.position - spawn_location.position) + rand_range(-PI / 8, PI / 8)

	obstacle.position = spawn_location.position
	obstacle.rotation = direction + PI

	var velocity = Vector2(rand_range(240, 500), 0)
	obstacle.linear_velocity = velocity.rotated(direction)

	add_child(obstacle)
	
	

func game_over():
	Global.playing = false
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	$SceneTimer.wait_time = 3
	$SceneTimer.start()
	save_score()


func atan3(v:Vector2):
	return atan2(v.y, v.x)


func save_score():
	if (Global.highscore[Global.difficulty - 1] < score):
		Global.highscore[Global.difficulty - 1] = score
	var save_file = File.new()
	save_file.open("user://highscore.save", File.WRITE)
	save_file.store_line(to_json({"highscore": Global.highscore}))
	save_file.close()
