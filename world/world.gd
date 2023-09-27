extends Node3D

const MAX_TICKS = 60

@onready var _label = $Control/Label
@onready var _control_timer = $ControlTimer
@onready var _spawn_point = $SpownPoint

signal start_test

var _is_running: bool = false
var _cubes: int = 0
var _fps: int = 0
var _fps_list: Array = []
var _ticks: int = 0


func _process(_delta: float) -> void:
	if not _is_running and Input.is_action_just_pressed("ui_accept"):
		_is_running = true
		_control_timer.start()
		emit_signal("start_test")
	else:
		_fps = Engine.get_frames_per_second()


func _on_spawner_instantiate_cube() -> void:
	_cubes = _cubes + 1


func _on_control_timer_timeout() -> void:
	_ticks = _ticks + 1
	_fps_list.append(_fps)
	
	var average: float = 0.0
	if _ticks >= MAX_TICKS:
		_control_timer.stop()
		var sum: int = 0
		for num in _fps_list:
			sum += num
		average = sum / MAX_TICKS
		
	if average > 0:
		_label.text = "Result: %s FPS with %s cubes" % [average, _cubes]
	else:
		_label.text = "FPS: %s\nCubes: %s" % [_fps, _cubes]
