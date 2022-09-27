extends PhysicsTestMotionParameters2D

class_name Soldier

#-------------------------
# Properties
#-------------------------
var army: Army
var layer: String = "front"
var texture: Texture = preload("res://icon.svg")
var soldier_shape
var query := PhysicsShapeQueryParameters2D.new()
var soldier_transform: Transform2D

var soldier_body
var collision_shape := CollisionShape2D.new()
var circle_shape := CircleShape2D.new()
var SHAPE_SIZE: int = 95

var soldier_name: int = randi_range(0, 100)

var space

var soldier_body
var circle_shape

#-------------------------
# Modifiers
#-------------------------
var speed: int = 250
var health: int
var radius: int

#-------------------------
# Components
#-------------------------
var movement_target: Vector2
var velocity_vector: Vector2
var soldier_position: Vector2

#-------------------------
# Setup Functions
#-------------------------
<<<<<<< Updated upstream
#see Army
=======
func spawn_soldier(new_position: Vector2, shared_area: Area2D, new_army: Army) -> Soldier:
	# Set soldier position and army
	soldier_position = new_position
	army = new_army

	# Create soldier body
	soldier_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(soldier_body, PhysicsServer2D.BODY_MODE_KINEMATIC)

	# Define Soldier shape position
	soldier_transform = Transform2D(0, soldier_position) #global variable
	soldier_transform.origin = soldier_position # doesn't the constructor ^ already do this?

	# Create Soldier area shape
	soldier_shape = PhysicsServer2D.circle_shape_create() #soldier_shape is property of Soldier
	PhysicsServer2D.shape_set_data(soldier_shape, SHAPE_SIZE)

	# Add soldier shape to body
	PhysicsServer2D.body_add_shape(soldier_body, soldier_shape)
	# Set body space
	PhysicsServer2D.call_deferred("body_set_space",soldier_body, army.get_world_2d().space)
#	PhysicsServer2D.body_set_space(soldier_body, army.get_world_2d().space)
	# Move initial position
	PhysicsServer2D.body_set_state(soldier_body, PhysicsServer2D.BODY_STATE_TRANSFORM, soldier_transform)

	circle_shape.set_radius(SHAPE_SIZE)
	collision_shape.set_shape(circle_shape)


	# Add shape to shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), soldier_shape, soldier_transform)

	return self
>>>>>>> Stashed changes

#-------------------------
# Runtime Functions
#-------------------------
<<<<<<< Updated upstream
# move soldier and collision area

=======
# move soldier and area shape
func soldier_move(delta: float, shared_area: Area2D, index: int, new_target: Vector2, all_soldiers: Array) -> void:
	# -Calculate velocity-
	velocity_vector = soldier_position.direction_to(new_target).normalized()

	# Move body position
	PhysicsServer2D.body_set_state(soldier_body, PhysicsServer2D.BODY_STATE_TRANSFORM, soldier_transform)

	# Move CollisionShape
	collision_shape.set_global_transform(soldier_transform)

#	print(body_test_motion_query())
	if body_test_motion_query():
		velocity_vector = Vector2.ZERO

#	var factor: int = all_soldiers.size()
#	if randi() % all_soldiers.size()/factor == 0:
#	shapes_collision(all_soldiers)

	# Finalize velocity vector
	velocity_vector *=  speed * delta
	# Adjust soldier and area shape position
	soldier_position += velocity_vector
	soldier_transform.origin = soldier_position
	PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), index, soldier_transform)
>>>>>>> Stashed changes



func shapes_collision(all_soldiers: Array):
	for soldier in all_soldiers:
		if soldier != self and soldier_position.distance_to(soldier.soldier_position) <= SHAPE_SIZE and velocity_vector.dot(soldier_position.direction_to(soldier.soldier_position).normalized()) > 0.75:
			velocity_vector -= soldier_position.direction_to(soldier.soldier_position)
#			var collision_array = collision_shape.get_shape().collide_and_get_contacts(soldier_transform, soldier.collision_shape.get_shape(),soldier.soldier_transform)
#			if !collision_array.is_empty():
##				print("Collision!")
#				for collision_vector in collision_array:
#					velocity_vector -= soldier_position.direction_to(collision_vector).normalized()



func body_test_motion_query():
	var query_params := PhysicsTestMotionParameters2D.new()
	query_params.set_from(soldier_transform)
	query_params.set_motion(velocity_vector)
	PhysicsServer2D.body_set_space(soldier_body, army.get_world_2d().space)
	var result := PhysicsServer2D.body_test_motion(soldier_body, query_params)
	var query_result := PhysicsTestMotionResult2D.new()
	print(query_result.get_collider_id())
	return result



# Courtesy of https://youtu.be/_z7Z7PrTD_M?list=TLPQMjYwOTIwMjJmsdq5_ETUBg&t=114
func shape_collision_query() -> Array:
	query.set_shape_rid(soldier_shape)
	query.collide_with_areas = true
	query.set_exclude([soldier_shape])
	query.collision_mask = 1
	query.transform = soldier_transform
	var result := army.get_world_2d().direct_space_state.intersect_shape(query, 4)
	return result





