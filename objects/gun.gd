extends XRToolsPickable

@onready
var magazine_snapzone = $"Root Scene/RootNode/Pistol/MagazineSnapZone"

var magazine

func on_magazine_loaded():
	pass

func on_magazine_ejected():
	magazine_snapzone.drop_object()
	
	magazine = null
	


func _on_magazine_snap_zone_has_picked_up(what):
	$AnimationPlayer.play("LoadMagazine")
	
	magazine = what

func _process(_delta):
	if is_picked_up() and get_picked_up_by_controller() and get_picked_up_by_controller().is_button_pressed("by_button"):
		if magazine:
			$AnimationPlayer.play("EjectMagazine")
