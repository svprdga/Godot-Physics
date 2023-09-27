extends Node3D

const CUBE_SCENE = preload("res://cube/cube.tscn")
const SPHERE_SCENE = preload("res://sphere/sphere.tscn")

signal instantiate_cube


func _on_timer_timeout():
	var object = CUBE_SCENE.instantiate()
	emit_signal("instantiate_cube")

	# Set position
	object.position = self.position
	
	# Random rotation
	object.rotation_degrees = Vector3(randf() * 360, randf() * 360, randf() * 360)
	
	add_child(object)
