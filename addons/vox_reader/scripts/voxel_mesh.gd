class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null
@export var generation_type: GEN_TYPE

@export var voxel_scale = .1;

@export var collisions: bool = true

var collider = null

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
			#for v in voxData.voxels:
				#voxData.voxels[v] = 0

				
					
			var mesh = GreedyGenerator.Generate(self, voxData, file_name)
			#mesh.create_debug_tangents()
			#mesh.create_trimesh_collision()
			
			var collisionMesh = GreedyGenerator.GenerateCollisionMesh(voxData)
			if(collisionMesh):
				#var shape = ConcavePolygonShape3D.new()
				#shape.set_faces(collisionMesh.surface_get_primitive_type())
				#add_child(shape)
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
					collisionMeshInstance.queue_free()	
				#collisionMeshInstance.create_debug_tangents()
				
	
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
	


