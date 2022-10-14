extends Area2D

signal hit

func _process(delta):
	if Global.playing:
		if (position.y < 0 or position.y > 1080):
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
