class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null
@export_enum("Unoptimized", "Greedy", "Culled") var generation_type: int
@export var collisions: bool = true
@export var voxel_scale = .1;

static var MeshPool = []

func _ready():
	voxData = VoxelImporter.open(file_path + file_name, null)
	
	match(generation_type):
		0:
			for v in voxData.voxels:
				await get_tree().create_timer(.05).timeout
				generate_block(v, voxData.voxels[v])
		_:
			print('Somehow you messed up the generation type')

func generate_block(_position, _colorIndex):
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.position = _position * voxel_scale;
	cube.mesh.material = StandardMaterial3D.new()
	cube.mesh.material.albedo_color = voxData.colors[_colorIndex]
	cube.scale = cube.scale * voxel_scale
	add_child(cube)
