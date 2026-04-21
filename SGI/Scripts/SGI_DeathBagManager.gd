extends Node
class_name SGI_DeathBagManager

const SGI_MainSrc: Resource = preload("res://SGI/Scripts/SGI_Main.gd")

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")
@export var sgiDeathBag = preload("res://SGI/Scenes/SGI_DeathBagDemo.tscn")


@onready var sgiMain = get_parent() as SGI_MainSrc

var deathPosition: Vector3 = Vector3(0,0,0)
var deathMap: String = "SGI_NO_DEATH"
var canSpawnDeathBag: bool = false


func _ready():
    get_tree().scene_changed.connect(OnNewSceneLoad)
    
func OnNewSceneLoad():
    call_deferred("OnSceneReady")

func OnSceneReady():
    if canSpawnDeathBag && deathMap == sgiMain.GetCurrentMapName():
        push_error("SGI: Spawning player body at " + str(deathPosition) + " in map " + deathMap)
        var inst = sgiDeathBag.instantiate() as Node3D
        get_tree().current_scene.add_child(inst)
        inst.global_position = deathPosition
        canSpawnDeathBag = false
        
    
func RegisterNewDeath(deathPos: Vector3, levelName: String):
    deathPosition = deathPos
    deathMap = levelName
    canSpawnDeathBag = true
