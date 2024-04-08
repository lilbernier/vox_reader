class_name GreedyGenerator


static func Generate(_root, _voxData):
	for v in _voxData.voxels:
		await _root.get_tree().create_timer(.05).timeout

