extends RigidBody3D
class_name GunCasing

func set_is_bullet(p_is_bullet):
	$Bullet.visible = p_is_bullet
	$Casing.visible = !p_is_bullet

func _on_lifetime_timer_timeout():
	queue_free()
