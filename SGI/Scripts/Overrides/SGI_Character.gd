# inspired by https://modworkshop.net/mod/55966
extends "res://Scripts/Character.gd"
class_name SGI_Character

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

func _physics_process(delta):
    if gameData.shelter and sgiConfig.allowStatMod: # overrides default decay.
        Health(delta)
        Stamina(delta)
        Energy(0)
        Hydration(0)
        Mental(0)
        Cat(0)
        Temperature(delta)
        Oxygen(delta)
        BurnDamage(delta)
        Clamp()
        return
    super(delta)
