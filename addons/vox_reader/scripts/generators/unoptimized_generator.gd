class_name UnoptimizedGenerator

static func Generate(_root, _voxData):
	var arrCubes = []
	for v in _voxData.voxels:
		#await _root.get_tree().create_timer(.05).timeout
		arrCubes.push_back(UnoptimizedGenerator.GenerateBlock(_root,_voxData, v, _voxData.voxels[v]))
	return arrCubes
	
		
static func GenerateBlock(_root, _voxData, _position, _colorIndex):
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.position = _position * _root.voxel_scale;
	cube.mesh.material = StandardMaterial3D.new()
	cube.mesh.material.albedo_color = _voxData.colors[_colorIndex]
	cube.scale = cube.scale * _root.voxel_scale
	_root.add_child(cube)
	return cube
	
