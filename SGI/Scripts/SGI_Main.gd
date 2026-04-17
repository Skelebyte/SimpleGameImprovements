extends Node
class_name SGI_Main

@export var versionMajor: int = 0
@export var versionMinor: int = 2
@export var versionPatch: int = 0

@export var sgiMenuOverlay: PackedScene = preload("res://SGI/Scenes/SGI_MenuOverlay.tscn")
#@export var sgiDebugOverlay: PackedScene = preload("res://SGI/Scenes/SGI_DebugOverlay.tscn")

const Map: Resource = preload("res://Scripts/Map.gd")
@onready var Menu: Resource = load("res://Scripts/Menu.gd")
const SGI_Character_Src: Resource = preload("res://SGI/Scripts/Overrides/SGI_Character.gd")

var lastScene: String = ""
@export var allowDebugOverlay: bool = false

func _ready():
    name = "SGI_Main"
    call_deferred("Setup")

func Setup():
    
    OverrideScript("res://SGI/Scripts/Overrides/SGI_Character.gd")
    OverrideScript("res://SGI/Scripts/Overrides/SGI_Placer.gd")
    get_tree().scene_changed.connect(OnNewSceneLoad)
    get_tree().reload_current_scene()

func OnNewSceneLoad():
    call_deferred("OnSceneReady")

func OnSceneReady():
    if get_tree().current_scene.get_script().resource_path == "res://Scripts/Menu.gd":
        CreateMenuOverlay("SGI Version: " + str(versionMajor) + "." + str(versionMinor) + "." + str(versionPatch))
    
    if get_tree().current_scene is Map:
        var map = get_tree().current_scene as Map
        if map.mapType == "Shelter":
            var playerGroup = get_tree().get_nodes_in_group("Player")
            if playerGroup == null:
                return
            var controller: CharacterBody3D
            for node in playerGroup:
                if node is CharacterBody3D and node.name == "Controller":
                    controller = node
                    break
                    
            var character = controller.get_node("Character") as SGI_Character_Src
            if character == null:
                push_error("SGI: Failed to get character!")
                return

func CreateMenuOverlay(contentOverride: String):
    print("SGI: Creating Menu Overlay")
    var inst = sgiMenuOverlay.instantiate()
    get_tree().current_scene.add_child(inst)
    var label = inst.get_node("SGI_Version") as Label
    label.text = contentOverride

func OverrideScript(path: String):
    var script = load(path)
    script.reload()
    var base = script.get_base_script()
    script.take_over_path(base.resource_path)
