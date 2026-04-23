extends "res://Scripts/LootContainer.gd"
class_name SGI_LootContainer

@export var preventDefaultReadyBehaviour: bool = false

func _ready():
    if preventDefaultReadyBehaviour:
        return
        
    super()
    
