extends Area2D

var master
@onready var pos = self.get_global_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master = get_parent()


func _physics_process(_delta: float) -> void:
	pos = self.get_global_position()
	self.set_global_position(master.army_target)
