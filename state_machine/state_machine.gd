extends Node

var current_state: State
var states: Dictionary = {}

@export var initial_state: State
@export var debug_mode: bool

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.change_state.connect(on_child_change_state)
	
	if initial_state:
		current_state = initial_state
		initial_state.enter()

func _process(delta: float) -> void:
	if debug_mode:
		Global.debug.add_debug_property("State",current_state,1)
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_change_state(state: State,new_state_name: String) -> void:
	if state != current_state: return
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if current_state: current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
