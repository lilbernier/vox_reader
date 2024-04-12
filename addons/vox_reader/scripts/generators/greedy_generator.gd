class_name GreedyGenerator



static func Generate(_root, _voxData):
	var surfaceTool: SurfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var faces = {}

	
	if _voxData.size() == 0:
		return surfaceTool.commit()
	
	#for v in _voxData:
		#mins.x = min(mins.x, v.x)
		#mins.y = min(mins.y, v.y)
		#mins.z = min(mins.z, v.z)
		#maxs.x = max(maxs.x, v.x)
		#maxs.y = max(maxs.y, v.y)
		#maxs.z = max(maxs.z, v.z)
	
	
	
	for orientation in FACE_ORIENTATIONS:
		GreedyGenerator.GenerateGeometryForOrientation(surfaceTool, _voxData, orientation)
	
	
	pass

static func GenerateGeometryForOrientation(_surfaceTool, _voxData, _orientation):
	var depthAxis :int = DEPTH_AXIS[_orientation]
	#var widthAxis :int = WIDTH_AXIS[_orientation]
	#var heightAxis :int = HEIGHT_AXIS[_orientation]
	#for slice in range(mins[depthAxis], maxs[depthAxis]+1):
			#var faces :Dictionary = query_slice_faces(voxel_data, o, slice)
			#if faces.size() > 0:
				#generate_geometry(faces, o, slice, scale, snaptoground)

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
	FRONT,
	BACK,
	LEFT,
	RIGHT,
	BOTTOM,
	TOP,
]


static var TOP = [
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3( 0.0000, 1.0000, 1.0000),
	Vector3( 0.0000, 1.0000, 0.0000),
	
	Vector3( 0.0000, 1.0000, 0.0000),
	Vector3( 1.0000, 1.0000, 0.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
];

static var BOTTOM = [
	Vector3( 0.0000, 0.0000, 0.0000),
	Vector3( 0.0000, 0.0000, 1.0000),
	Vector3( 1.0000, 0.0000, 1.0000),
	
	Vector3( 1.0000, 0.0000, 1.0000),
	Vector3( 1.0000, 0.0000, 0.0000),
	Vector3( 0.0000, 0.0000, 0.0000),
];

static var FRONT = [
	Vector3( 0.0000, 1.0000, 1.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3( 1.0000, 0.0000, 1.0000),
	
	Vector3( 1.0000, 0.0000, 1.0000),
	Vector3( 0.0000, 0.0000, 1.0000),
	Vector3( 0.0000, 1.0000, 1.0000),
];

static var BACK = [
	Vector3( 1.0000, 0.0000, 0.0000),
	Vector3( 1.0000, 1.0000, 0.0000),
	Vector3( 0.0000, 1.0000, 0.0000),
	
	Vector3( 0.0000, 1.0000, 0.0000),
	Vector3( 0.0000, 0.0000, 0.0000),
	Vector3( 1.0000, 0.0000, 0.0000)
];

const LEFT = [
	Vector3( 0.0000, 1.0000, 1.0000),
	Vector3( 0.0000, 0.0000, 1.0000),
	Vector3( 0.0000, 0.0000, 0.0000),
	
	Vector3( 0.0000, 0.0000, 0.0000),
	Vector3( 0.0000, 1.0000, 0.0000),
	Vector3( 0.0000, 1.0000, 1.0000),
];

const RIGHT = [
	Vector3( 1.0000, 1.0000, 1.0000),
	Vector3( 1.0000, 1.0000, 0.0000),
	Vector3( 1.0000, 0.0000, 0.0000),
	
	Vector3( 1.0000, 0.0000, 0.0000),
	Vector3( 1.0000, 0.0000, 1.0000),
	Vector3( 1.0000, 1.0000, 1.0000),
];
