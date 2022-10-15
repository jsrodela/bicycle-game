extends Area2D

signal hit

const y_range = 30


func _process(delta):
	if Global.playing:
		if (position.y < - y_range or position.y > 1080 + y_range):
			hit()


func _on_Player_body_entered(body):
	hit()


func hit():
	hide()
	emit_signal("hit")
	$CollisionPolygon2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
