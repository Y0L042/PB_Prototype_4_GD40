extends RefCounted

class_name Soldier

#-------------------------
# Properties
#-------------------------
var shape_id: RID
var layer: String = "front"
var texture: Texture = load("res://icon.svg")

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
var current_position: Vector2

#-------------------------
# Setup Functions
#-------------------------
func spawn_soldier(new_position: Vector2, shared_area: Area2D) -> Soldier:
	# Set soldier position
	current_position = new_position

	# Define Soldier shape position
	var RADIUS: int = 50
	var soldier_transform = Transform2D(0, current_position)
	soldier_transform.origin = current_position # doesn't the constructor ^ already do this?

	# Create Soldier area shape
	var _circle_shape := PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, RADIUS)

	# Add shape to shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), _circle_shape, soldier_transform)

	return self

#-------------------------
# Runtime Functions
#-------------------------
# move soldier and area shape
func soldier_move(delta: float, shared_area: Area2D, index: int, soldier_transform: Transform2D, new_target: Vector2) -> void:
	# Calculate velocity
	velocity_vector = current_position.direction_to(new_target).normalized() * speed * delta

	# Adjust soldier and area shape position
	current_position += velocity_vector
	soldier_transform.origin = current_position
	PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), index, soldier_transform)

