class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String
var voxData = null
@export var generation_type: GEN_TYPE

@export var voxel_scale = .1;

@export var collisions: bool = true


enum GEN_TYPE{
	GREEDY,
	CUBE,
	GPT,
	GPT2
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
		GEN_TYPE.GPT:
			var palette = voxData.colors
			var size = voxData.size
			var voxels = voxData.voxels

			var cube_mesh = BoxMesh.new()
			cube_mesh.size = Vector3.ONE

			for voxel in voxels:
				var mesh_instance = MeshInstance3D.new()
				mesh_instance.mesh = cube_mesh
				mesh_instance.transform.origin = Vector3(voxel.x, voxel.y, voxel.z)
				
				var color_index = voxData.voxels[voxel]#voxel.color_index
				var color = palette[color_index]

				var material = StandardMaterial3D.new()
				material.albedo_color = color
				mesh_instance.material_override = material

				add_child(mesh_instance)
		GEN_TYPE.GPT2:
			gpt2()
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
	
	
	
	
func gpt2():
	var voxels = voxData.voxels
	var palette = voxData.colors

	var mesh = BoxMesh.new()
	mesh.size = Vector3.ONE

	var color_groups = {}  # color_index: [Vector3, Vector3, ...]

	for voxel in voxels:
		var color_index = voxData.voxels[voxel] #voxel.color_index
		if not color_groups.has(color_index):
			color_groups[color_index] = []
		color_groups[color_index].append(Vector3(voxel.x, voxel.y, voxel.z))

	for color_index in color_groups.keys():
		var positions = color_groups[color_index]

		var multimesh = MultiMesh.new()
		multimesh.mesh = mesh
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.instance_count = positions.size()

		for i in positions.size():
			var xform = Transform3D.IDENTITY.translated(positions[i])
			multimesh.set_instance_transform(i, xform)

		var color = palette[color_index]
		var material = StandardMaterial3D.new()
		material.albedo_color = color

		var mm_instance = MultiMeshInstance3D.new()
		mm_instance.multimesh = multimesh
		mm_instance.material_override = material

		add_child(mm_instance)
	
