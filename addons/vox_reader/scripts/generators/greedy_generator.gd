class_name GreedyGenerator



static func Generate(_root, _voxData):
	var surfaceTool: SurfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var faces = {}
	var mins = Vector3.INF
	var maxs = -Vector3.INF
	
	if _voxData.voxels.size() == 0:
		return surfaceTool.commit()
		
	for v in _voxData.voxels:
		mins.x = min(mins.x, v.x)
		mins.y = min(mins.y, v.y)
		mins.z = min(mins.z, v.z)
		maxs.x = max(maxs.x, v.x)
		maxs.y = max(maxs.y, v.y)
		maxs.z = max(maxs.z, v.z)
	
	print('MIN' + str(mins))
	print('MAX' + str(maxs))

	for orientation in FACE_ORIENTATIONS:
		GreedyGenerator.GenerateGeometryForOrientation(surfaceTool, _voxData, orientation, mins, maxs)
	
	surfaceTool.generate_normals()
	var material = StandardMaterial3D.new()
	material.vertex_color_is_srgb = true
	material.vertex_color_use_as_albedo = true
	material.roughness = 1
	surfaceTool.set_material(material)
	
	var mesh = MeshInstance3D.new()
	mesh.mesh = surfaceTool.commit();
	_root.add_child(mesh)
	return 

static func GenerateGeometryForOrientation(_surfaceTool, _voxData, _orientation, _mins, _maxs):
	var depthAxis :int = DEPTH_AXIS[_orientation]
	
	for slice in range(_mins[depthAxis], _maxs[depthAxis] + 1):
		var faces = GreedyGenerator.QuerySliceFaces(_voxData, depthAxis,_orientation, slice)
		if(faces.size() > 0):
			GreedyGenerator.GenerateGeometry(_surfaceTool,_voxData, faces, depthAxis, _orientation, slice, _mins, _maxs)
			pass

				
				
static func QuerySliceFaces(_voxData, _depthAxis, _orientation, _slice):
	var ret = Dictionary()
	for v in _voxData.voxels:
		if(v[_depthAxis] == _slice  && _voxData.voxels.has(v + FACE_CHECKS[_orientation]) == false):
			ret[v] = _voxData.voxels[v]
	return ret


static func GenerateGeometry(_surfaceTool,_voxData, _faces,_depthAxis, _orienation, _slice, _mins, _maxs):
	var widthAxis :int = WIDTH_AXIS[_orienation]
	var heightAxis :int = HEIGHT_AXIS[_orienation]
	var v :Vector3 = Vector3()
	v[_depthAxis] = _slice
	
	#Iterate the rows of the sparse volume
	v[heightAxis] = _mins[heightAxis]
	while v[heightAxis] <= _maxs[heightAxis]:
		# Iterate over the voxels of the row
		v[widthAxis] = _mins[widthAxis]
		while v[widthAxis] <= _maxs[widthAxis]:
			if _faces.has(v):
				GreedyGenerator.GenerateGeometryForFace(_surfaceTool,_voxData, _faces, v, _orienation, _depthAxis, widthAxis, heightAxis, _mins)
			v[widthAxis] += 1.0
		v[heightAxis] += 1.0
		
static func GenerateGeometryForFace(_surfaceTool,_voxData, _faces, _face,_orienation, _depthAxis, _widthAxis, _heightAxis, _mins):
	var width :int = GreedyGenerator.WidthQuery(_faces, _face, _widthAxis, _orienation)
	var height :int = GreedyGenerator.HeightQuery(_faces, _face, _orienation, _heightAxis, _widthAxis, width)
	
	var grow :Vector3 = Vector3(1, 1, 1)
	grow[_widthAxis] *= width
	grow[_heightAxis] *= height

	# Generate geometry
	var yoffset = Vector3(0,0,0);
	#if snaptoground : yoffset = Vector3(0, -mins.z * scale, 0);

	var basis = Basis(Vector3.RIGHT, Vector3.FORWARD, Vector3.UP)
	
	_surfaceTool.set_color(_voxData.colors[_faces[_face]])
	for vert in FACE_MESHES[_orienation]:
		var xform = basis * (((vert * grow) + _face) * .1)
		_surfaceTool.add_vertex(yoffset + xform)
	
	# Remove these faces from the pool
	var v :Vector3 = Vector3()
	v[_depthAxis] = _face[_depthAxis]
	for iy in range(height):
		v[_heightAxis] = _face[_heightAxis] + float(iy)
		for ix in range(width):
			v[_widthAxis] = _face[_widthAxis] + float(ix)
			_faces.erase(v)
	
	return _faces 
	
static func WidthQuery(_faces, _face, _widthAxis, _orientation):
	#var wd :int = width_axis[o]
	var v = _face

	while _faces.has(v) and _faces[v] == _faces[_face]:
		v[_widthAxis] += 1.0
	return int(v[_widthAxis] - _face[_widthAxis])
	
	
static func HeightQuery(_faces, _face,  _orientation, _heightAxis, _widthAxis, _width):
	#var hd :int = height_axis[o]
	var c = _faces[_face]
	var v  = _face
	v[_heightAxis] += 1.0
	while _faces.has(v) and _faces[v] == c and GreedyGenerator.WidthQuery(_faces, v, _widthAxis,_orientation) >= _width:
		v[_heightAxis] += 1.0
	return int(v[_heightAxis] - _face[_heightAxis])

	
	
enum FaceOrientation {
	Top = 0,
	Bottom = 1,
	Left = 2,
	Right = 3,
	Front = 4,
	Back = 5,
}

# An Array(FaceOrientation) of all possible face orientations
static var FACE_ORIENTATIONS :Array = [
	FaceOrientation.Top,
	FaceOrientation.Bottom,
	FaceOrientation.Left,
	FaceOrientation.Right,
	FaceOrientation.Front,
	FaceOrientation.Back
]

# An Array(int) of the depth axis by orientation
static var DEPTH_AXIS :Array = [
	Vector3.AXIS_Z,
	Vector3.AXIS_Z,
	Vector3.AXIS_X,
	Vector3.AXIS_X,
	Vector3.AXIS_Y,
	Vector3.AXIS_Y,
]

# An Array(int) of the width axis by orientation
static var WIDTH_AXIS:Array = [
	Vector3.AXIS_Y,
	Vector3.AXIS_Y,
	Vector3.AXIS_Z,
	Vector3.AXIS_Z,
	Vector3.AXIS_X,
	Vector3.AXIS_X,
]

# An Array(int) of height axis by orientation
static var HEIGHT_AXIS :Array = [
	Vector3.AXIS_X,
	Vector3.AXIS_X,
	Vector3.AXIS_Y,
	Vector3.AXIS_Y,
	Vector3.AXIS_Z,
	Vector3.AXIS_Z,
]

# An Array(Vector3) describing what vectors to use to check for face occlusion
# by orientation
static var FACE_CHECKS :Array = [
	Vector3(0, 0, 1),
	Vector3(0, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, -1, 0),
	Vector3(0, 1, 0),
]

# An array of the face meshes by orientation
static var FACE_MESHES :Array = [
	Faces.FRONT,
	Faces.BACK,
	Faces.LEFT,
	Faces.RIGHT,
	Faces.BOTTOM,
	Faces.TOP,
]
