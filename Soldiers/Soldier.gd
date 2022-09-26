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
func spawn_soldier(new_position: Vector2,    shared_area: Area2D) -> Soldier:
	var soldier: Soldier = Soldier.new()
	soldier.current_position = new_position
	configure_soldier_collision(shared_area, soldier, soldier.current_position)
	return soldier

func configure_soldier_collision(shared_area: Area2D, soldier: Soldier, soldier_position: Vector2) -> void:
	# Define Soldier shape position
	var RADIUS: int = soldier.radius
	var soldier_transform = Transform2D(0, soldier_position)
	soldier_transform.origin = soldier.current_position # doesn't the constructor ^ already do this?

	# Create Soldier shape
	var _circle_shape := PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, RADIUS)

	# Add shape to shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), _circle_shape, soldier_transform)

#-------------------------
# Runtime Functions
#-------------------------
# move soldier and collision area
func soldier_move(delta: float, shared_area: Area2D, index: int, soldier_transform: Transform2D, new_target: Vector2):
	velocity_vector = self.current_position.direction_to(new_target).normalized() * speed * delta

#	var query := PhysicsShapeQueryParameters2D.new()
#	query.set_shape()


	current_position += velocity_vector
	soldier_transform.origin = current_position
	PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), index, soldier_transform)

