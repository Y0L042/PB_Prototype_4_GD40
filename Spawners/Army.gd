extends Node2D

class_name Army



# var sprite images
var army_position: Vector2 = Vector2.ZERO
var army_target: Vector2 = Vector2.ZERO

@export var soldier_amount: int = 0
@onready var shared_area: Area2D = $SharedArea

var all_soldiers: Array = []
var active_soldiers: Array = []

#-------------------------
# Initialization
#-------------------------
func _ready() -> void:
	for index in range(0, soldier_amount):
		var soldier = Soldier.new()
		append_to_arrays(soldier.spawn_soldier(random_offset(army_position), shared_area, self))


#-------------------------
# Runtime
#-------------------------
func _physics_process(delta: float) -> void:
	army_target = get_target()

	for index in range(0, active_soldiers.size()): #
		var soldier: Soldier = active_soldiers[index]

		soldier.soldier_move(delta, shared_area, index, army_target)

	queue_redraw()




func _draw() -> void:
	# Ysorting soldiers
	all_soldiers.sort_custom(func ysort(a, b): return a.soldier_position.y < b.soldier_position.y)

	for index in range(0, all_soldiers.size()):
		var soldier = all_soldiers[index]
		draw_texture(soldier.texture, soldier.soldier_position)


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
	var radius: int = 500
	var offset: Vector2 = center_point
	offset.x += randi_range(-radius, radius)
	offset.y += randi_range(-radius, radius)
	return offset
