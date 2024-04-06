class_name VoxelMesh extends Node

@export var file_path:String
@export var file_name:String

func _ready():
	VoxelImporter.open(file_path + file_name, null)
