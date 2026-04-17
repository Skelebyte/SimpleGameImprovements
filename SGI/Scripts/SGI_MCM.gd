extends Node

#const MOD_ID = "Simple Game Improvements"
#const FILE_PATH = "user://MCM/" + MOD_ID
#
#func _ready() -> void:
    #var _config = ConfigFile.new()
    #_config.set_value("Bool", "allowDebugOverlay", {
        #"name" = "Allow Debug Overlay",
        #"tooltip" = "When enabled, a debug overlay will appear on the right hand side of the screen.",
        #"default" = false,
        #"value" = false
    #})
    #
    #if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
        #DirAccess.open("user://").make_dir(FILE_PATH)
        #_config.save(FILE_PATH + "/config.ini")
    #else:
        #_config.load(FILE_PATH + "/config.ini")
