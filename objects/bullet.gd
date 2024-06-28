extends RigidBody3D


func _ready():
	pass
	
	
func _on_body_entered(body : StaticBody3D):
	var format_string  = "Collided with: %s"
	var actual_string = format_string % str(body.name)
	print(actual_string)
	if body.get_parent().visible == true and not Points.is_game_over:
		Points.points +=10
		body.get_parent().visible = false
