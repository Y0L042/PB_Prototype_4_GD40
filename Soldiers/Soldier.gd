extends PhysicsTestMotionParameters2D

class_name Soldier

#-------------------------
# Properties
#-------------------------
var shape_id: RID
var layer: String = "front"
var texture: Texture = load("res://icon.svg")

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
var current_position: Vector2

#-------------------------
# Setup Functions
#-------------------------
#see Army

#-------------------------
# Runtime Functions
#-------------------------
# move soldier and collision area


