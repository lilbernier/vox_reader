class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null
@export var generation_type: GEN_TYPE

@export var voxel_scale = .1;

@export var collisions: bool = true

enum GEN_TYPE{
	GREEDY,
	CUBE
}

func _ready():
	voxData = VoxelImporter.open(file_path + file_name, null)
	var time_start = Time.get_ticks_msec()

	match(generation_type):
		GEN_TYPE.GREEDY: #GREEDY
			#for i in 200:
				#print('Greedy mesh.')
			GreedyGenerator.Generate(self, voxData, file_name)

		GEN_TYPE.CUBE: #CUBE
			print('Unoptimized mesh.')
			UnoptimizedGenerator.Generate(self, voxData)
			#for v in voxData.voxels:
				#await get_tree().create_timer(.05).timeout
				#generate_block(v, voxData.voxels[v])
		_:
			print('Somehow you messed up the generation type')
	
	var time_now = Time.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print('GENERATOR TYPE: ' + str(generation_type) + ' ' + str(time_elapsed))
