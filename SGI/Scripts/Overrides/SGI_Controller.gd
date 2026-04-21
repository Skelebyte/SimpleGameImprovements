extends "res://Scripts/Controller.gd"
class_name SGI_Controller

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

func MovementStates(delta):
    super(delta)
    if sgiConfig.allowMovementMod:
        MovementMod()
        

func MovementMod():
    if gameData.interface: 
        return
    if gameData.isCrouching && Input.is_action_just_pressed("sprint"):
        gameData.isCrouching = false
