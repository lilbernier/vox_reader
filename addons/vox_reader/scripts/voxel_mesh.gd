class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null

func _ready():
	voxData = VoxelImporter.open(file_path + file_name, null)
	#print(voxData.voxels)
	for v in voxData.voxels:
		print(voxData.voxels[v])
		await get_tree().create_timer(.05).timeout
		generate_block(v, voxData.voxels[v])

func generate_block(_position, _colorIndex):
	
	
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.position = _position;
	cube.mesh.material = StandardMaterial3D.new()
	cube.mesh.material.albedo_color = voxData.colors[_colorIndex]
	
	cube.scale = Vector3(1, 1, 1)
	add_child(cube)
