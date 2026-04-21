# inspired by https://modworkshop.net/mod/55966
extends "res://Scripts/Character.gd"
class_name SGI_Character

const Map: Resource = preload("res://Scripts/Map.gd")
const SGI_MainSrc: Resource = preload("res://SGI/Scripts/SGI_Main.gd")
const SGI_DeathBagManagerSrc: Resource = preload("res://SGI/Scripts/SGI_DeathBagManager.gd")

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")
var sgiCrosshairScene: PackedScene = preload("res://SGI/Scenes/SGI_Crosshair.tscn")
var sgiCrosshair: Control = null

var sgiMain: SGI_MainSrc
var sgiDeathBagManager: SGI_DeathBagManagerSrc

func _ready():
    sgiCrosshair = sgiCrosshairScene.instantiate()
    get_tree().current_scene.add_child.call_deferred(sgiCrosshair)
    sgiMain = get_tree().get_first_node_in_group("SGI_Main") as SGI_MainSrc
    sgiDeathBagManager = get_tree().get_first_node_in_group("SGI_DeathBagManager") as SGI_DeathBagManagerSrc
        
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

func Death():
    push_error("SGI: Player has died!")
    if !gameData.permadeath and !gameData.tutorial:
        push_error("SGI: Death pos = " + str(get_parent().global_position))
        if sgiMain.GetCurrentMapName() == "SGI_NOT_A_MAP":
            push_error("SGI: Failed to get current scene as Map!")
        else:
            print("SGI: Death map = " + sgiMain.GetCurrentMapName())
            sgiDeathBagManager.RegisterDeath(
                get_parent().global_position, 
                (get_tree().current_scene as Map).mapName
            )

    super()

func CheckStuff():
    push_error("SGI: Checking stuff!")
