extends Node2D

var compute_shader_string: String

func _ready():

	var shader_file = load(compute_shader_string)
	var shader_bytecode = shader_file.get_bytecode()
	var rd = RenderingServer.create_local_rendering_device()
	var shader = rd.shader_create(shader_bytecode)
	var pipeline = rd.compute_pipeline_create(shader)

	var storage_buffer = rd.storage_buffer_create(64)
	var u = RDUniform.new()
	u.type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	u.binding = 0
	u.add_id(storage_buffer)
	var uniform_set = rd.uniform_set_create([u], shader, 0)

	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, 8, 1, 1)
	rd.compute_list_end()


