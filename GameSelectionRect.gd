extends ReferenceRect

signal game_selected(difficulty)

onready var progress_bar = $GameSelectionProgress
onready var timer = $GameSelectionTimer

var screen_width = 1920
var speed:float = 4
var selection_delay:float = 2
var progress_id:int = 0

func _ready():
	progress_bar.value = 0
	timer.connect("timeout", self, "_on_timer_timeout")


func _process(_delta):
	if (Input.is_action_pressed("move")):
		rect_position.x += speed
		if (rect_position.x > screen_width + border_width):
			rect_position.x -= screen_width + border_width*2 + rect_size.x

	progress_id = 0
	for i in range(1,4):
		if (abs((rect_position.x + rect_size.x/2) - (3*i-1) * 0.1 * screen_width) < border_width + 40):
			progress_id = i
			break

	if progress_id:
		border_color = Color(1, 1, 0, 0.75)
		if timer.is_stopped():
				timer.start(selection_delay)
				$SelectionSFX.play()
		progress_bar.value = 100 * (selection_delay - timer.time_left) / selection_delay
	else:
		progress_bar.value = 0
		border_color = Color(1, 1, 0, 0.25)
		timer.stop()
		$SelectionSFX.stop()


func _on_timer_timeout():
	# Emit signal to start selected game
	emit_signal("game_selected", progress_id)
