extends Node3D

var xr_interface:XRInterface

@onready var target1 : MeshInstance3D = $target1
@onready var target2 : MeshInstance3D = $target2
@onready var target3 : MeshInstance3D = $target3
@onready var target4 : MeshInstance3D = $target4
@onready var target5 : MeshInstance3D = $target5
@onready var target6 : MeshInstance3D = $target6
@onready var target7 : MeshInstance3D = $target7
@onready var target8 : MeshInstance3D = $target8
@onready var target9 : MeshInstance3D = $target9
@onready var target10 : MeshInstance3D = $target10
@onready var target11 : MeshInstance3D = $target11
@onready var target12 : MeshInstance3D = $target12
@onready var target13 : MeshInstance3D = $target13
@onready var target14 : MeshInstance3D = $target14
@onready var target15 : MeshInstance3D = $target15
@onready var target16 : MeshInstance3D = $target16
@onready var target17 : MeshInstance3D = $target17
@onready var target18 : MeshInstance3D = $target18
@onready var target19 : MeshInstance3D = $target19
@onready var target20 : MeshInstance3D = $target20
@onready var target21 : MeshInstance3D = $target21
@onready var target22 : MeshInstance3D = $target22
@onready var target23 : MeshInstance3D = $target23
@onready var target24 : MeshInstance3D = $target24
@onready var target25 : MeshInstance3D = $target25
@onready var target26 : MeshInstance3D = $target26
@onready var target27 : MeshInstance3D = $target27
@onready var target28 : MeshInstance3D = $target28
@onready var target29 : MeshInstance3D = $target29
@onready var target30 : MeshInstance3D = $target30
@onready var target31 : MeshInstance3D = $target31
@onready var target32 : MeshInstance3D = $target32
@onready var target33 : MeshInstance3D = $target33
@onready var target34 : MeshInstance3D = $target34
@onready var target35 : MeshInstance3D = $target35
@onready var target36 : MeshInstance3D = $target36
@onready var target37 : MeshInstance3D = $target37



# Called when the node enters the scene tree for the first time.
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialised? please check if your headset is connected")
	
func _process(delta):
	$XROrigin3D/XRCamera3D/LabelPoints.text = str(Points.points)
	if not Points.is_game_over:
		$XROrigin3D/XRCamera3D/RemainingTime.text = str(Points.time)
	else:
		$XROrigin3D/XRCamera3D/RemainingTime.text = "GAME OVER"
func _on_target_expire_timer_timeout():
	var targets_array : Array[MeshInstance3D] = [target1, target2, target3, target4, target5, target6, target7, target8, target9, target10,
											target11, target12, target13, target14, target15, target16, target17, target18, target19, target20,
											target21, target22, target23, target24, target25, target26, target27, target28, target29, target30,
											target31, target32, target33, target34, target35, target36, target37]
	for target in targets_array:
		target.visible = false
	targets_array.shuffle()
	for i in range (5):
		targets_array[i].visible = true


func _on_time_timer_timeout():
	Points.time -=1
	if Points.time == 1:
		$TimeTimer.one_shot = true
	if Points.time == 0:
		Points.is_game_over = true
