extends Node2D

var mouse_input : Vector2
var following : bool = false

@onready var icon : Sprite2D = $Sprite
@onready var pointer : Sprite2D = $Pointer
@onready var state : Label = $VBoxContainer/State

func _ready() -> void:
	show_state()

func _unhandled_input( event : InputEvent )-> void:
	if event is InputEventMouseMotion:
		mouse_input += event.relative


func _process ( _delta : float )-> void:
	if Input.is_anything_pressed():
		change_mode()
		show_state()
	
	if Input.mouse_mode != 0:
		pointer.position += mouse_input
	
	if following:
		icon.position += mouse_input
	mouse_input = Vector2.ZERO

func change_mode()->void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	# Turn accumulated_input on/off
	if Input.is_action_just_pressed("accumulator_toggle"):
		Input.set_use_accumulated_input( !Input.use_accumulated_input )
	
	# Start/stop dragging icon
	if Input.is_action_just_pressed("drag"):
		following = !following
		# reset icon location if it got lost somewhere
		if icon.position.distance_to( get_mouse_pos() ) > 90:
			icon.position = get_mouse_pos()
	
	# Capture mouse and replace it with software mouse
	if Input.is_action_just_pressed("capture_mouse"):
		pointer.self_modulate = Color(0.92, 0.598, 0.652, 1.0)
		pointer.position = get_mouse_pos()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pointer.show()
	
	# Replace mouse with software mouse
	if Input.is_action_just_pressed("software_mouse"):
		pointer.self_modulate = Color(0.598, 0.92, 0.657, 1.0)
		pointer.position = get_mouse_pos()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		pointer.show()
	
	# Normal system mouse
	if Input.is_action_just_pressed("normal_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pointer.hide()
	
	if Input.is_action_just_pressed("v-sync"):
		var mode : int = ( DisplayServer.window_get_vsync_mode() + 1 ) % 4
		DisplayServer.window_set_vsync_mode( mode )
		
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_FULLSCREEN )
		else:
			DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_WINDOWED )

func get_mouse_pos()->Vector2:
	if Input.mouse_mode == 0:
		return get_global_mouse_position()
	else:
		return pointer.global_position

func show_state()->void:
	var txt  :String = ""
	if following:
		txt += "Dragging\n"
	else:
		txt += "-\n"
	if Input.mouse_mode == 0:
		txt += "System mouse\n"
	elif Input.mouse_mode == 1:
		txt += "Software mouse\n"
	elif Input.mouse_mode == 2:
		txt += "Captured software mouse\n"
	
	if DisplayServer.window_get_vsync_mode() == 0:
		txt += "V-sync disabled\n"
	elif DisplayServer.window_get_vsync_mode() == 1:
		txt += "v-sync enabled\n"
	elif DisplayServer.window_get_vsync_mode() == 2:
		txt += "v-sync adaptive\n"
	elif DisplayServer.window_get_vsync_mode() == 3:
		txt += "v-sync mailbox\n"
	
	txt += "Accumulate input: " + str( Input.use_accumulated_input )
	
	state.text = txt
