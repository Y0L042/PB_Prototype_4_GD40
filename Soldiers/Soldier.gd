extends RefCounted

class_name Soldier

#-------------------------
# Properties
#-------------------------
var shape_id: RID
var layer: String = "front"
var texture: Texture = load("res://icon.svg")

var soldier_shape
var soldier_body
var soldier_transform: Transform2D
var soldier_army

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
func spawn_soldier(new_position: Vector2, shared_area: Area2D, new_soldier_army: Army) -> Soldier:
	# Set soldier position
	soldier_position = new_position
	soldier_army = new_soldier_army

	create_soldier_shape()
	create_soldier_body()

	# Add shape to shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), soldier_shape, soldier_transform)

	return self

func create_soldier_shape():
		# Define Soldier shape position
	var RADIUS: int = 50
	soldier_transform = Transform2D(0, soldier_position)
	soldier_transform.origin = soldier_position # doesn't the constructor ^ already do this?

	# Create Soldier area shape
	soldier_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(soldier_shape, RADIUS)


func create_soldier_body():
	soldier_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(soldier_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_add_shape(soldier_body, soldier_shape)
#	PhysicsServer2D.body_set_space(soldier_body, soldier_army.get_world_2d().space)
	PhysicsServer2D.call_deferred("body_set_space", soldier_body, soldier_army.get_world_2d().space)
	PhysicsServer2D.body_set_state(soldier_body, PhysicsServer2D.BODY_STATE_TRANSFORM, soldier_transform)


#-------------------------
# Runtime Functions
#-------------------------
# move soldier and area shape
func soldier_move(delta: float, shared_area: Area2D, index: int, new_target: Vector2) -> void:
	# Calculate velocity
	velocity_vector = soldier_position.direction_to(new_target).normalized() * speed * delta

	# Adjust soldier and area shape position
	soldier_position += velocity_vector
	soldier_transform.origin = soldier_position
	PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), index, soldier_transform)

