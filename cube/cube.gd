extends RigidBody3D


func _ready():
	var color = Color(randf(), randf(), randf(), 1.0)
	var material = $MeshInstance3D.mesh.material.duplicate()
	material.albedo_color = color
	$MeshInstance3D.mesh.material = material
