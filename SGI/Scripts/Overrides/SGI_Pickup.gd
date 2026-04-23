extends "res://Scripts/Pickup.gd"

const WeaponDataSrc = preload("res://Scripts/WeaponData.gd");
var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

func _ready():
    push_error("SGI: SGI_Pickup ready")
    super()

func UpdateTooltip():
    push_warning("SGI: here")
    if sgiConfig.allowAmmoOnTooltip:
        OverridenUpdateTooltip()
    else:
        super()


func OverridenUpdateTooltip():
    if slotData.itemData.showAmount:
        gameData.tooltip = slotData.itemData.name + " [" + "x" + str(slotData.amount) + "]"
        return


    if slotData.itemData.carrier && slotData.nested.size() != 0:

        for nested in slotData.nested:

            if nested.plate:
                gameData.tooltip = slotData.itemData.name + " [" + nested.rating + "]"
                return


    gameData.tooltip = slotData.itemData.name

    if slotData.itemData is WeaponData:
        var dataAsWD = slotData.itemData as WeaponData
        gameData.tooltip = "(" + dataAsWD.caliber + ") " + gameData.tooltip

    if slotData.itemData.file == "Cat" && gameData.catDead: gameData.tooltip += " (RIP)"

    push_error("SGI: " + gameData.tooltip)