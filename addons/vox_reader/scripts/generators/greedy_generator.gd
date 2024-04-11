class_name GreedyGenerator


static var surfaceTool: SurfaceTool = SurfaceTool.new()

static func Generate(_root, _voxData):
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	pass


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
