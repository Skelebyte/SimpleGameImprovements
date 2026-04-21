extends Control
class_name SGI_Crosshair

var gameData = preload("res://Resources/GameData.tres")
var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

@export var alphaChangeSpeed: float = 10.0

func _ready() -> void:
    pass
        

func _process(delta: float) -> void:
    if sgiConfig.allowCrosshairMod == false:
        modulate.a = 0.0
        return
    
    var shouldHide = (
        gameData.isAiming or
        gameData.isCanted or
        gameData.isReloading or
        gameData.isInspecting or
        gameData.isInserting or
        gameData.isChecking or
        gameData.isClearing or
        gameData.isDrawing or
        gameData.isDragging or
        gameData.isOccupied or
        gameData.isCrafting or
        gameData.isTrading or
        gameData.isPlacing or
        gameData.isSleeping or
        gameData.isScoped or
        gameData.isFiring or
        gameData.interface or 
        gameData.settings or
        gameData.isDead
    )
    
    if shouldHide:
        modulate.a = lerp(modulate.a, 0.0, delta * alphaChangeSpeed)
    else:
        modulate.a = lerp(modulate.a, 1.0, delta * alphaChangeSpeed)
