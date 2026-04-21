extends "res://Scripts/HUD.gd"
class_name SGI_HUD

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

func _process(_delta: float) -> void:
    if sgiConfig.allowCrosshairMod:
        var pos = (tooltip as Control).position
        (tooltip as Control).position = Vector2(pos.x, 540)
        
    else:
        var pos = (tooltip as Control).position
        (tooltip as Control).position = Vector2(pos.x, 520)
        
