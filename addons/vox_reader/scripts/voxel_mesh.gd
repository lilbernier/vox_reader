class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null
@export_enum("Unoptimized", "Greedy", "Culled") var generation_type: int

@export var voxel_scale = .1;

@export var collisions: bool = true

@export var animated: bool = false


func _ready():
	voxData = VoxelImporter.open(file_path + file_name, null)
	var time_start = Time.get_ticks_msec()


	match(generation_type):
		0: #Unoptimized
			print('Unoptimized mesh.')
			UnoptimizedGenerator.Generate(self, voxData)
			#for v in voxData.voxels:
				#await get_tree().create_timer(.05).timeout
				#generate_block(v, voxData.voxels[v])
		1:
			#for i in 200:
				#print('Greedy mesh.')
			GreedyGenerator.Generate(self, voxData, file_name)
		2:
			pass
			#print('Culled mesh.')
		_:
			print('Somehow you messed up the generation type')
	
	var time_now = Time.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print('GENERATOR TYPE: ' + str(generation_type) + ' ' + str(time_elapsed))
	
func generate_block(_position, _colorIndex):
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.position = _position * voxel_scale;
	cube.mesh.material = StandardMaterial3D.new()
	cube.mesh.material.albedo_color = voxData.colors[_colorIndex]
	cube.scale = cube.scale * voxel_scale
	add_child(cube)
