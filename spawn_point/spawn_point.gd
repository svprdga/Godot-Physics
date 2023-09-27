extends Node3D

const CUBE_SCENE = preload("res://cube/cube.tscn")
const TIMER_INTERVAL = 0.01

signal instantiate_cube

var _elapsed_time: float = 0.0


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	_elapsed_time += delta
	if _elapsed_time >= TIMER_INTERVAL:
		_elapsed_time = 0.0
		_instantiate_cube()


func _on_world_start_test():
	set_process(true)


func _instantiate_cube():
	var object = CUBE_SCENE.instantiate()
	emit_signal("instantiate_cube")

	# Set position
	object.position = self.position
	
	# Random rotation
	object.rotation_degrees = Vector3(randf() * 360, randf() * 360, randf() * 360)
	
	add_child(object)
