extends Node2D

class_name Army



# var sprite images
var army_position: Vector2 = Vector2.ZERO
var army_target: Vector2 = Vector2.ZERO

var BASE_SOLDIER: Soldier
@export var soldier_amount: int = 0
@onready var shared_area: Area2D = $SharedArea

@onready var params = PhysicsTestMotionParameters2D.new()

var all_soldiers: Array = []
var active_soldiers: Array = []

var world_space

#-------------------------
# Initialization
#-------------------------
func _ready() -> void:
	world_space = get_viewport().world_2d.space
	for index in range(0, soldier_amount):
		var soldier = Soldier.new()
<<<<<<< Updated upstream
		append_to_arrays(spawn_soldier(soldier))

=======
		append_to_arrays(soldier.spawn_soldier(random_offset(army_position), shared_area, self))
>>>>>>> Stashed changes


#-------------------------
# Runtime
#-------------------------
func _physics_process(delta: float) -> void:
<<<<<<< Updated upstream

	var soldier_transform = Transform2D()
=======
>>>>>>> Stashed changes
	army_target = get_target()

	for index in range(0, active_soldiers.size()): #
		var soldier: Soldier = active_soldiers[index]
<<<<<<< Updated upstream
		soldier_move(soldier, delta, army_target, soldier_transform, index)
=======
		soldier.soldier_move(delta, shared_area, index, army_target, all_soldiers)
>>>>>>> Stashed changes

	queue_redraw()


<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
func _draw() -> void:
	for index in range(0, all_soldiers.size()):
		var soldier = all_soldiers[index]
		var draw_position: Vector2 = soldier.soldier_position - Vector2(soldier.SHAPE_SIZE, soldier.SHAPE_SIZE)*1.3
		draw_texture(soldier.texture, draw_position)



func exit_tree() -> void:
	pass


#-------------------------
# Public
#-------------------------
func append_to_arrays(soldier: Soldier):
	all_soldiers.append(soldier)
	active_soldiers.append(soldier)



func get_target() -> Vector2:
	var target: Vector2
#	target = get_global_mouse_position()
	target = get_local_mouse_position()
	return target



func random_offset(center_point: Vector2) -> Vector2:
	var radius: int = 1000
	var offset: Vector2 = center_point
	offset.x += randi_range(-radius, radius)
	offset.y += randi_range(-radius, radius)
	return offset



#-------------------------
# Soldier Functions
#-------------------------
func spawn_soldier(soldier: Soldier):
	# Set soldier position
	soldier.current_position = random_offset(army_position)
	configure_soldier_collision(soldier)
	return soldier



func configure_soldier_collision(soldier: Soldier) -> void:
	# Define Soldier shape position
	var RADIUS: int = 300

	# Set soldier transform (position)
	var soldier_transform = Transform2D(0, soldier.current_position)
	soldier_transform.origin = soldier.current_position # doesn't the constructor ^ already do this?

	# Create soldier collision body
	soldier.soldier_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(soldier.soldier_body, PhysicsServer2D.BODY_MODE_KINEMATIC)

	# Create Soldier shape
	soldier.circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(soldier.circle_shape, RADIUS)

	# Add shape to body
	PhysicsServer2D.body_add_shape(soldier.soldier_body, soldier.circle_shape)

	# Set body collision space
	PhysicsServer2D.call_deferred("body_set_space", soldier.soldier_body, world_space)

	# Move initial position
	PhysicsServer2D.body_set_state(soldier.soldier_body, PhysicsServer2D.BODY_STATE_TRANSFORM, soldier_transform)

	# Add shape to shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), soldier.circle_shape, soldier_transform)



func soldier_move(soldier: Soldier, delta: float, new_target: Vector2, soldier_transform: Transform2D, index: int):
	# Calculate Soldier velocity to target
	soldier.velocity_vector = soldier.current_position.direction_to(new_target).normalized() * soldier.speed * delta

	# Test for collision during motion
	params.set_from(soldier_transform)
	params.set_motion(soldier.velocity_vector)
#	if PhysicsServer2D.body_test_motion(soldier.soldier_body, params):
#		soldier.velocity_vector = Vector2.ZERO



	# Add velocity to position, ZERO if collision occurs
	soldier.current_position += soldier.velocity_vector
	soldier_transform.origin = soldier.current_position

	# Move body
#	PhysicsServer2D.body_set_state(soldier.soldier_body, PhysicsServer2D.BODY_STATE_TRANSFORM, soldier_transform)

	# Apply force to body
	PhysicsServer2D.body_apply_force(soldier.soldier_body, soldier.velocity_vector)
	PhysicsServer2D.body_get_continuous_collision_detection_mode()

	# Move shape in shared_area
	PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), index, soldier_transform)
