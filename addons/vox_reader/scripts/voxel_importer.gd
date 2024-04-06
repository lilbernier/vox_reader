class_name VoxelImporter extends Node




static var PooledContent = []
static var Debugger = true;

func _ready():
	pass


static func open(source_path, destination_path):
	#var scale = 0.1
	#if options.Scale:
		#scale = float(options.Scale)
	#var greedy = true
	#if options.has("GreedyMeshGenerator"):
		#greedy = bool(options.GreedyMeshGenerator)
	#var snaptoground = false
	#if options.has("SnapToGround"):
		#snaptoground = bool(options.SnapToGround)
	#var mergeKeyframes = false
	#if options.has("FirstKeyframeOnly"):
		#mergeKeyframes = not bool(options.FirstKeyframeOnly)
	var file = FileAccess.open(source_path, FileAccess.READ)
	#var content = file.get_as_text()
	#var error = str_to_var(content)
	
	#if error != null: 
		#var data_received = error 
		#if typeof(data_received) == TYPE_DICTIONARY: 
			#print(data_received) # Prints dictionary else: print("Unexpected data")


	var identifier = PackedByteArray([ file.get_8(), file.get_8(), file.get_8(), file.get_8() ]).get_string_from_ascii()
	var version = file.get_32()
	#print('Importing: ', source_path, ' (scale: ', scale, ', file version: ', version, ', greedy mesh: ', greedy, ', snap to ground: ', snaptoground, ')');
	var vox = VoxelData.new();
	if identifier == 'VOX ':
		var voxFile = VoxelFile.new(file);
		var index = 0
		while voxFile.has_data_to_read():
			#print(index)
			#index += 1
			VoxelImporter.ReadChunk(vox, voxFile);
			
	file.close()
	
	
static func ReadChunk(_voxData, _voxFile):
	var chunk_id = _voxFile.get_string(4);
	var chunk_size = _voxFile.get_32();
	var childChunks = _voxFile.get_32()

	_voxFile.set_chunk_size(chunk_size);
	
	match chunk_id:
		'SIZE':
			_voxData.current_index += 1;
			#var model = vox.get_model();
			#var x = file.get_32();
			#var y = file.get_32();
			#var z = file.get_32();
			#model.size = Vector3(x, y, z);
			#if VoxelImporter.Debugger: print('SIZE ', model.size);
		'XYZI':
			#var model = vox.get_model();
			if VoxelImporter.Debugger: print('XYZI');
			for _i in range(_voxFile.get_32()):
				var x = _voxFile.get_8()
				var y = _voxFile.get_8()
				var z = _voxFile.get_8()
				var c = _voxFile.get_8()
				var voxel = Vector3(x, y, z)
				#model.voxels[voxel] = c - 1
				if VoxelImporter.Debugger: print('\t', voxel, ' ', c-1);
		'RGBA':
			if VoxelImporter.Debugger: print('RGBA');
			
			#vox.colors = []
			#for _i in range(256):
				#var r = float(file.get_8() / 255.0)
				#var g = float(file.get_8() / 255.0)
				#var b = float(file.get_8() / 255.0)
				#var a = float(file.get_8() / 255.0)
				#vox.colors.append(Color(r, g, b, a))
		'nTRN':
			if VoxelImporter.Debugger: print('nTRN');

		'nGRP':
			if VoxelImporter.Debugger: print('nGRP');
		'nSHP':
			if VoxelImporter.Debugger: print('nSHP');
		'MATL':
			var material_id = _voxFile.get_32() - 1;
			var properties = _voxFile.get_vox_dict();
			#vox.materials[material_id] = VoxMaterial.new(properties);
			if VoxelImporter.Debugger:
				print("MATL ", material_id);
				print("\t", properties);
		'LAYR':
			var layer_id = _voxFile.get_32();
			var attributes = _voxFile.get_vox_dict();
			var isVisible = true;
			if '_hidden' in attributes and attributes['_hidden'] == '1':
				isVisible = false;
			
			if VoxelImporter.Debugger: print('LAYR ' + str(isVisible));
			#var layer = VoxLayer.new(layer_id, isVisible);
			#vox.layers[layer_id] = layer;
		_:
			if VoxelImporter.Debugger: print(chunk_id);
	_voxFile.read_remaining();
