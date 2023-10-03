extends Node3D

#const TIMER_INTERVAL = 0.01
const TIMER_INTERVAL = 1.0

signal instantiate_cube

const SCALE = 2.0

var _elapsed_time: float = 0.0

var _cubes: Array = []
var _meshes: Array = []

var _shape: BoxShape3D = BoxShape3D.new()
var _box_mesh: BoxMesh = BoxMesh.new()
var _materials: Array = []


func _ready():
	set_process(false)


func _physics_process(delta):
	for i in range(_cubes.size()):
		var transform = PhysicsServer3D.body_get_state(_cubes[i], PhysicsServer3D.BODY_STATE_TRANSFORM)
		RenderingServer.instance_set_transform(_meshes[i], transform)


func _process(delta: float) -> void:
	pass
	_elapsed_time += delta
	if _elapsed_time >= TIMER_INTERVAL:
		_elapsed_time = 0.0
		_instantiate_cube()


func _on_world_start_test():
	set_process(true)
			

func _instantiate_cube():
	emit_signal("instantiate_cube")
	
	# Create cube
	var cube = PhysicsServer3D.body_create()
	_cubes.append(cube)
	PhysicsServer3D.body_set_mode(cube, PhysicsServer3D.BODY_MODE_RIGID)
	
	# Add cube to space
	var space = get_world_3d().space
	PhysicsServer3D.body_set_space(cube, space)
		
	# Add shape
	_shape.extents = Vector3(1.0, 1.0, 1.0)
	PhysicsServer3D.body_add_shape(cube, _shape)
	PhysicsServer3D.body_set_shape_transform(cube, 0, Transform3D(Basis.IDENTITY, Vector3.ZERO))
	
	# Set transform
	var transform = Transform3D(Basis.IDENTITY, position)
	PhysicsServer3D.body_set_state(cube, PhysicsServer3D.BODY_STATE_TRANSFORM, transform)
	
	# Add mesh
	_box_mesh.size = Vector3(SCALE, SCALE, SCALE)
	var mesh = RenderingServer.instance_create2(_box_mesh, get_world_3d().scenario)
	_meshes.append(mesh)
	RenderingServer.instance_set_transform(mesh, transform)
	
	# Set random color
	var cube_material = StandardMaterial3D.new()
	_materials.append(cube_material)
	cube_material.albedo_color = Color(randf(), randf(), randf(), 1.0)
	
	# Add the material to the cube
	RenderingServer.instance_set_surface_override_material(mesh, 0, cube_material)
