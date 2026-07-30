extends Node

var inventory_open: bool = false

func _enter_tree() -> void:
    
    if is_multiplayer_authority():
        return
    
    remove_comps()

func _physics_process(delta: float) -> void:
    if not is_multiplayer_authority():
        return
    
    var inventory: Node2D = $inventory
    
    if Input.is_action_just_pressed("inventory"):
        inventory_open = not inventory_open
        $"../Pivot/heads/head".inventory_open = inventory_open
        inventory.get_child(0).visible = inventory_open


func remove_comps():
    $inventory.queue_free()
