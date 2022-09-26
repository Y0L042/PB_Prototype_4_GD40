extends Area2D

var master
var pos = self.get_global_position()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pos = self.get_global_position()
	self.set_global_position(master.army_target)
