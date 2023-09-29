extends Camera3D


const SENSITIVITY: float = 0.001
const SPEED: float = 30.0

var is_movement: float = false
var rot_x: float = 0.0
var rot_y: float = 0.0


func _process(delta: float):
	# Manage exit with ESC
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	# Manage enter movement mode
	if Input.is_action_just_pressed("enter_movement"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_movement = true
		
	if not is_movement:
		return
	
	# Camera movement
	var movement = Vector3(0, 0, 0)
	if Input.is_action_pressed('move_forward'):
		movement.z -= 1
	if Input.is_action_pressed('move_backward'):
		movement.z += 1
	if Input.is_action_pressed('move_left'):
		movement.x -= 1
	if Input.is_action_pressed('move_right'):
		movement.x += 1
	if Input.is_action_pressed('move_up'):
		movement.y += 1
	if Input.is_action_pressed('move_down'):
		movement.y -= 1

	movement = movement.normalized()

	self.translate(movement * SPEED * delta)

	# Camera rotation
	rot_x -= Input.get_last_mouse_velocity().y * SENSITIVITY
	rot_y -= Input.get_last_mouse_velocity().x * SENSITIVITY

	rot_x = clamp(rot_x, -70, 70)

	self.rotation_degrees = Vector3(rot_x, rot_y, 0)
