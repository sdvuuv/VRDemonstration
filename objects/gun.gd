extends XRToolsPickable

enum GunState{
	GUN_UNLOADED,
	GUN_LOADED,
	GUN_FIRED
}

@export var casing_scene : PackedScene
@export var bullet_scene : PackedScene
@onready var magazine_snapzone = $"Root Scene/RootNode/Pistol/MagazineSnapZone"
@onready var slide_origin : Node3D = $SlideOrigin
@onready var slide_pickup : XRToolsPickable = $SlideOrigin/SlidePickup
@onready var slide_org_pos = $"Root Scene/RootNode/Pistol/slide".transform.origin

var max_pullback_slide = 0.075
var gun_state = GunState.GUN_UNLOADED
var slide_layer

var magazine : GunMagazine

func action():
	if $AnimationPlayer.is_playing():
		return
	
	if gun_state == GunState.GUN_LOADED:
		$AnimationPlayer.play("Shoot")
	else:
		$AnimationPlayer.play("EmptyShoot")

func _ready():
	super()
	slide_layer = slide_pickup.collision_layer
	slide_pickup.collision_layer = 0
	
func on_magazine_loaded():
	pass

func on_magazine_ejected():
	magazine_snapzone.drop_object()
	
	magazine = null
	


func _on_magazine_snap_zone_has_picked_up(what):
	$AnimationPlayer.play("LoadMagazine")
	
	magazine = what

func _shoot_bullet():
	if bullet_scene:
		var new_scene = bullet_scene.instantiate()
		if new_scene:
			new_scene.top_level = true
			add_child(new_scene)
			new_scene.transform = $BulletSpawnPoint.global_transform
			new_scene.linear_velocity = new_scene.transform.basis.z * 20.0
	
	gun_state = GunState.GUN_FIRED

func _eject_and_load():
	# If bullet/shell is loaded, eject
	if gun_state != GunState.GUN_UNLOADED:
		_eject_bullet()

	# If bullet in magazine, load bullet
	if magazine and magazine.has_bullets():
		magazine.take_bullet()
		gun_state = GunState.GUN_LOADED

	_update_bullets()

func _eject_bullet():
	# eject our bullet
	if casing_scene:
		print(1)
		var new_scene : GunCasing = casing_scene.instantiate()
		if new_scene:
			new_scene.set_is_bullet(gun_state == GunState.GUN_LOADED)
			new_scene.top_level = true
			add_child(new_scene)
			new_scene.transform = $"Root Scene/RootNode/Pistol/slide/CasingSpawnPoint".global_transform
			new_scene.linear_velocity = new_scene.transform.basis.y * 1.0
	gun_state = GunState.GUN_UNLOADED

func _update_bullets():
	$"Root Scene/RootNode/Pistol/slide/LoadedBullet".visible = gun_state == GunState.GUN_LOADED
	$"Root Scene/RootNode/Pistol/slide/FiredBullet".visible = gun_state == GunState.GUN_FIRED

func _process(_delta):
	if is_picked_up() and get_picked_up_by_controller() and get_picked_up_by_controller().is_button_pressed("by_button"):
		if magazine:
			$AnimationPlayer.play("EjectMagazine")

	if slide_pickup.is_picked_up():
		print("picked")
		var slide_pickup_pos = slide_pickup.global_transform.origin
		var slide_pickup_local = slide_pickup_pos * slide_origin.global_transform
		
		var pullback = max(0.0, -slide_pickup_local.z)
		
		print(pullback)
		if pullback > 0.1:
			pass
		elif pullback < max_pullback_slide:
			$"Root Scene/RootNode/Pistol/slide".transform.origin = slide_org_pos - Vector3(0.0, 0.0, pullback)
		else:
			#If bullet/shell is loaded, eject
			if gun_state != GunState.GUN_UNLOADED:
				_eject_bullet()
			#If bullet in magazine, load bullet
			if magazine and magazine.has_bullets():
				magazine.take_bullet()
				gun_state = GunState.GUN_LOADED
				
			_update_bullets()
			
			$"Root Scene/RootNode/Pistol/hammer".rotate_x(-40)
			slide_pickup.drop()
func _on_Gun_picked_up(pickable):
	slide_pickup.enabled = true
	if slide_pickup.enabled:
		print("ready to pick")
	slide_pickup.collision_layer = slide_layer
	

func _on_Gun_dropped(pickable):
	if slide_pickup.is_picked_up():
		slide_pickup.drop()
	slide_pickup.enabled = false
	slide_pickup.collision_layer = 0

func _on_slide_pickup_dropped(pickable):
	$"Root Scene/RootNode/Pistol/slide".transform.origin = slide_org_pos
	slide_pickup.transform = Transform3D()
	slide_pickup.collision_layer = slide_layer
