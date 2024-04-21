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

var mesh_instance = null
var collision_body = null


func _ready():
	voxData = VoxelImporter.open(file_path + file_name, null)
	print('Amount Voxels ' + str(voxData.voxels.size()))
	generate(true)
	#print(voxData.voxels)
	
	#await self.get_tree().create_timer(5).timeout
	#var timeWait = .75
	#destroy_on_point(Vector3(0, 1, 0))
	#await self.get_tree().create_timer(timeWait).timeout
	#destroy_on_point(Vector3(1, 0, 0))
	#await self.get_tree().create_timer(timeWait).timeout
	#destroy_on_point(Vector3(1, 1, 0))	
	#await self.get_tree().create_timer(timeWait).timeout
	#destroy_on_point(Vector3(1, 1,1))
	#await self.get_tree().create_timer(timeWait).timeout
	#destroy_on_point(Vector3(0, 1,1))	
	#await self.get_tree().create_timer(timeWait).timeout
	#destroy_on_point(Vector3(1, 0,1))			

func generate(_initial = false):
	var time_start = Time.get_ticks_msec()
	match(generation_type):
		GEN_TYPE.GREEDY: #GREEDY
			var useFileName = file_name if _initial else null
			var mesh = GreedyGenerator.Generate(self, voxData, useFileName)
			mesh_instance = mesh
			var collisionMesh = GreedyGenerator.GenerateCollisionMesh(voxData)
			if(collisionMesh):
				var collisionMeshInstance = MeshInstance3D.new()
				collisionMeshInstance.mesh = collisionMesh
				add_child(collisionMeshInstance)			
				collisionMeshInstance.create_trimesh_collision()
				
				var staticBody = null
				for child in collisionMeshInstance.get_children():
					if child is StaticBody3D:
						staticBody = child
				
				if(staticBody):
					staticBody.reparent(mesh)
					collision_body = staticBody
					collisionMeshInstance.queue_free()	
		GEN_TYPE.CUBE: #CUBE
			print('Unoptimized mesh.')
			var meshes = UnoptimizedGenerator.Generate(self, voxData)
			
			for m in meshes:
				m.create_debug_tangents()
				m.create_trimesh_collision()
		_:
			print('Somehow you messed up the generation type')
	
	var time_now = Time.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print('GENERATOR TYPE: ' + str(generation_type) + ' ' + str(time_elapsed))


func clear_mesh():
	if(mesh_instance): mesh_instance.queue_free()
	if(collision_body): collision_body.queue_free()


func destroy_on_point(_point):
	if(!voxData.voxels.has(_point)): return
	voxData.voxels.erase(_point)
	clear_mesh()
	generate(false)
	
