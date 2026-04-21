extends Node
class_name SGI_Config

var sgiConfigSettings = preload("res://SGI/Config/SGI_ConfigSettings.tres")
var MCM_Helpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")

const MOD_ID = "SimpleGameImprovements"
const FILE_PATH = "user://MCM/SGI"

func _ready():
    var config = ConfigFile.new()
    config.set_value(
        "Bool", "allowDeathBagMod", {
        "name" = "Allow Death Bag Mod",
        "tooltip" = "When enabled, a bag with the loot you were carrying will spawn at the location of death.\nThe bag will only spawn once per level load.\nThis feature must be enabled at the time of death in order to function",
        "default" = false,
        "value" = false
    })
    config.set_value(
        "Bool", "allowMovementMod", {
        "name" = "Allow Movement Mod",
        "tooltip" = "When enabled, changes to movement such as being able to transition to a sprint from couch will be enabled.",
        "default" = true,
        "value" = true
    })
    config.set_value(
        "Bool", "allowCrosshairMod", {
        "name" = "Allow Crosshair Mod",
        "tooltip" = "When enabled, a small crosshair will be visible in the center of the screen.",
        "default" = false,
        "value" = false
    })
    config.set_value(
        "Bool", "allowStatMod", {
        "name" = "Allow Stat Mod",
        "tooltip" = "When enabled, Energy, Hydration, Mental, and Cat stats will not decrease while in shelter.",
        "default" = true,
        "value" = true
    })
    config.set_value(
        "Bool", "allowPlaceMod", {
        "name" = "Allow Place Mod",
        "tooltip" = "When enabled, the speed that items move and rotate are modified while being placed.",
        "default" = true,
        "value" = true
    })
    config.set_value("Float", "placeCollisionEnableWaitTime", {
       "name" = "Collision Enable Wait Time",
       "tooltip" = "After starting to place an object, the game will wait this amount until it collides with the world.",
       "default" = 0.1,
       "value" = 0.75,
       "minRange" = 0.0,
       "maxRange" = 10.0
    })
    config.set_value("Float", "placeMoveSpeed", {
       "name" = "Item Move Speed",
       "tooltip" = "After starting to place an object, items will move at this speed.",
       "default" = 5.0,
       "value" = 12.5,
       "minRange" = 0.1,
       "maxRange" = 50.0
    })
    config.set_value("Float", "placeRotateSpeed", {
       "name" = "Item Move Speed",
       "tooltip" = "After starting to place an object, items will rotate at this speed.",
       "default" = 7.5,
       "value" = 12.5,
       "minRange" = 0.1,
       "maxRange" = 50.0
    })
    config.set_value("Float", "placeOrientSpeed", {
       "name" = "Item Move Speed",
       "tooltip" = "After starting to place an object, items will orient at this speed.",
       "default" = 5.0,
       "value" = 12.5,
       "minRange" = 0.1,
       "maxRange" = 50.0
    })
    config.set_value("Float", "placeDistance", {
       "name" = "Item Move Speed",
       "tooltip" = "After starting to place an object, items move to be this distance away from the player.",
       "default" = 1.0,
       "value" = 0.5,
       "minRange" = 0.1,
       "maxRange" = 1
    })
    
    if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
        DirAccess.open("user://").make_dir(FILE_PATH)
        config.save(FILE_PATH + "/config.ini")
    else:
        MCM_Helpers.CheckConfigurationHasUpdated(MOD_ID, config, FILE_PATH + "/config.ini")
        config.load(FILE_PATH + "/config.ini") 
        
    MCM_Helpers.RegisterConfiguration(
        MOD_ID, 
        "Simple Game Improvements", 
        FILE_PATH, "TODO desc", 
        {
            "config.ini" = UpdateConfigProperties
        }
    )
    
    UpdateConfigProperties(config)
    
func UpdateConfigProperties(config: ConfigFile):
    sgiConfigSettings.allowDeathBagMod = config.get_value("Bool", "allowDeathBagMod")["value"]
    sgiConfigSettings.allowMovementMod = config.get_value("Bool", "allowMovementMod")["value"]
    sgiConfigSettings.allowCrosshairMod = config.get_value("Bool", "allowCrosshairMod")["value"]
    sgiConfigSettings.allowStatMod = config.get_value("Bool", "allowStatMod")["value"]
    sgiConfigSettings.allowPlaceMod = config.get_value("Bool", "allowPlaceMod")["value"]
    sgiConfigSettings.placeCollisionEnableWaitTime = config.get_value("Float", "placeCollisionEnableWaitTime")["value"]
    sgiConfigSettings.placeMoveSpeed = config.get_value("Float", "placeMoveSpeed")["value"]
    sgiConfigSettings.placeRotateSpeed = config.get_value("Float", "placeRotateSpeed")["value"]
    sgiConfigSettings.placeOrientSpeed = config.get_value("Float", "placeOrientSpeed")["value"]
    sgiConfigSettings.placeDistance = config.get_value("Float", "placeDistance")["value"]
    
