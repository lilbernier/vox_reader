class_name UnoptimizedGenerator

static func Generate(_root, _voxData):
	for v in _voxData.voxels:
		await _root.get_tree().create_timer(.05).timeout
		UnoptimizedGenerator.GenerateBlock(_root, v, _voxData.voxels[v])

static func GenerateBlock(_root, _position, _colorIndex):
	#var cube = MeshInstance3D.new()
	#cube.mesh = BoxMesh.new()
	#cube.position = _position * voxel_scale;
	#cube.mesh.material = StandardMaterial3D.new()
	#cube.mesh.material.albedo_color = voxData.colors[_colorIndex]
	#cube.scale = cube.scale * voxel_scale
	#_root.add_child(cube)
	
