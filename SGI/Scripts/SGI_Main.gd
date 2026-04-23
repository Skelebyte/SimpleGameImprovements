extends Node
class_name SGI_Main

var gameData = preload("res://Resources/GameData.tres")
var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

@export var versionMajor: int = 0
@export var versionMinor: int = 5
@export var versionPatch: int = 0

@export var sgiMenuOverlay: PackedScene = preload("res://SGI/Scenes/SGI_MenuOverlay.tscn")
@export var sgiDeathBag = preload("res://SGI/Scenes/SGI_Corpse.tscn")
#@export var sgiCrosshair: PackedScene = preload("res://SGI/Scenes/SGI_Crosshair.tscn")
#@export var sgiDebugOverlay: PackedScene = preload("res://SGI/Scenes/SGI_DebugOverlay.tscn")

const Map: Resource = preload("res://Scripts/Map.gd")
@onready var Menu: Resource = load("res://Scripts/Menu.gd")
const SGI_Character_Src: Resource = preload("res://SGI/Scripts/Overrides/SGI_Character.gd")
const SGI_LootContainer_Src: Resource = preload("res://SGI/Scripts/Overrides/SGI_LootContainer.gd")

var lastScene: String = ""
@export var allowDebugOverlay: bool = false

var deathPosition: Vector3 = Vector3(0,0,0)
var deathMap: String = "SGI_NO_DEATH"
var canSpawnDeathBag: bool = false
var deathBagContent: Array[SlotData]


func _ready():
    name = "SGI_Main"
    call_deferred("Setup")

func Setup():
    OverrideScript("res://SGI/Scripts/Overrides/SGI_Character.gd")
    OverrideScript("res://SGI/Scripts/Overrides/SGI_Placer.gd")
    OverrideScript("res://SGI/Scripts/Overrides/SGI_HUD.gd")
    OverrideScript("res://SGI/Scripts/Overrides/SGI_Controller.gd")
    OverrideScript("res://SGI/Scripts/Overrides/SGI_LootContainer.gd")
    get_tree().scene_changed.connect(OnNewSceneLoad)
    get_tree().reload_current_scene() # required for version number to appear when first loading menu

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
                if node is CharacterBody3D && node.name == "Controller":
                    controller = node
                    break
                    
            var character = controller.get_node("Character") as SGI_Character_Src
            if character == null:
                push_error("SGI: Failed to get character!")
                return
    
    if gameData.catDead && gameData.catFound && sgiConfig.allowCatRespawnMod:
        gameData.cat = 100.0
        gameData.catFound = false;
        gameData.catDead = false;

    print("SGI: canSpawnDeathBag: " + str(canSpawnDeathBag))
    print("SGI: current map: " + GetCurrentMapName() + ", deathMap: " + deathMap)

    if sgiConfig.allowDeathBagMod && canSpawnDeathBag && deathMap == GetCurrentMapName():
        print("SGI: Spawning player body at " + str(deathPosition) + " in map " + deathMap)
        var inst = sgiDeathBag.instantiate() as Node3D
        get_tree().current_scene.add_child(inst)
        inst.global_position = Vector3(deathPosition.x, deathPosition.y + 1, deathPosition.z)
        var container = inst as SGI_LootContainer_Src
        if container == null:
            push_error("SGI: Failed to get SGI_LootContainer!")
        else:
            for slot in deathBagContent:
                var newSlotData = SlotData.new()
                newSlotData.amount = slot.amount
                newSlotData.condition = slot.condition
                newSlotData.chamber = slot.chamber
                newSlotData.nested = slot.nested
                newSlotData.storage = slot.storage
                if slot.itemData is WeaponData:
                    newSlotData.itemData = slot.itemData as WeaponData
                else:
                    newSlotData.itemData = slot.itemData
                container.loot.append(newSlotData)
        deathBagContent.clear()
        canSpawnDeathBag = false
        deathMap = "SGI_NO_DEATH"
        
    
        

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

func GetCurrentMapName() -> String:
    if get_tree().current_scene is Map:
        var map = get_tree().current_scene as Map
        return map.mapName
    return "SGI_NOT_A_MAP"

func RegisterNewDeath(deathPos: Vector3, levelName: String):
    deathPosition = deathPos
    deathMap = levelName
    canSpawnDeathBag = true
    #var character: CharacterSave = load("user://Character.tres") as CharacterSave
    var interface = get_tree().current_scene.get_node("/root/Map/Core/UI/Interface")
    for item in interface.inventoryGrid.get_children():
        deathBagContent.push_back(item.slotData)
        print("SGI: Adding " + item.slotData.itemData.name + " to bag.")
    print("SGI: Registering death: pos = " + str(deathPosition) + " | map = " + str(deathMap) + " | canSpawn = " + str(canSpawnDeathBag) + " | deathBagContent size: " + str(deathBagContent.size()))
