extends "res://Scripts/Placer.gd"
class_name SGI_Placer

var sgiConfig = preload("res://SGI/Config/SGI_ConfigSettings.tres")

#var sgiMain: SGI_Main

func _ready() -> void:
    if sgiConfig.allowPlaceMod:
        waitTime = 0.75
        position.z = -0.5
    #sgiMain = get_tree().get_first_node_in_group("SGI_Main")\

func _physics_process(delta):
    if sgiConfig.allowPlaceMod:
        OverriddenPlacing(delta)
    else:
        super(delta)
       
func ContextPlace(target: Node3D):
    if sgiConfig.allowPlaceMod:
        OverriddenContextPlace(target)
    else:
        super(target)

func OverriddenContextPlace(target: Node3D):
    if gameData.decor:

            distance = 2.0
            angle = 0.0


            position = - transform.basis.z * distance
            target.global_position = global_position


            for child in target.get_children():
                if child is Furniture:
                    furniture = child


            placable = target
            gameData.isPlacing = true
            furniture.StartMove()


    else:
        placable = target
        placable.body_entered.connect(self.Collided)
        gameData.isPlacing = true

        placable.rotation.x = deg_to_rad(0)
        placable.rotation.z = deg_to_rad(0)
        placable.linear_velocity = Vector3.ZERO
        placable.angular_velocity = Vector3.ZERO

        distance = 0.5
        angle = 0.0
        orientationMode = 1

        position = ( - transform.basis.z * distance) + ( - transform.basis.y * placable.mesh.get_aabb().get_center().y)
        placable.global_position = global_position
        placable.global_rotation.y = global_rotation.y + deg_to_rad(placable.slotData.itemData.orientation) + angle


        placable.Freeze()
        initialWait = true
        await get_tree().create_timer(waitTime, false).timeout;
        initialWait = false
        placable.Kinematic()
  
func OverriddenPlacing(delta: float):
    if gameData.freeze || gameData.isReloading || gameData.isInspecting:
        return

    if Input.is_action_just_pressed(("place")) && gameData.decor:
        if gameData.interaction && interactor.target && interactor.target.is_in_group("Furniture") && !gameData.isPlacing:


            position = - transform.basis.z * 0.0

            var distanceToTarget = global_position.distance_to(interactor.target.owner.global_position)

            distance = distanceToTarget


            angle = 0.0

            placable = interactor.target.owner
            gameData.isPlacing = true


            for child in placable.get_children():
                if child is Furniture:
                    furniture = child

            furniture.StartMove()

        elif gameData.isPlacing && placable && furniture.CanPlace():
            furniture.ResetMove()
            placable = null
            furniture = null
            gameData.isPlacing = false

    if Input.is_action_just_pressed(("place")) && !gameData.decor:

        if gameData.interaction && interactor.target && interactor.target.is_in_group("Item") && !gameData.isPlacing && !initialWait:
            distance = sgiConfig.placeDistance #position.distance_to(interactor.target) # NOT ACTUALLY SURE WHAT THIS DOES
            angle = 0.0
            orientationMode = 1

            placable = interactor.target
            placable.body_entered.connect(self.Collided)
            gameData.isPlacing = true

            #print("SGI: Item Position (" + str(placable.position.x) + ", " + str(placable.position.y) + ", " + str(placable.position.z) + ")")
            #print("SGI: Item RotationDeg (" + str(placable.rotation_degrees.x) + ", " + str(placable.rotation_degrees.y) + ", " + str(placable.rotation_degrees.z) + ")")

            placable.linear_velocity = Vector3.ZERO
            placable.angular_velocity = Vector3.ZERO


            placable.Freeze()
            initialWait = true
            await get_tree().create_timer(waitTime, false).timeout;
            initialWait = false
            placable.Kinematic()


        elif gameData.isPlacing && placable && !initialWait:
            placable.body_entered.disconnect(self.Collided)
            placable.linear_velocity = Vector3(0, 0.1, 0)
            placable.angular_velocity = Vector3(1, 1, 1)
            placable.Unfreeze()
            placable = null
            gameData.isPlacing = false


    if gameData.isPlacing && placable && !gameData.decor:

        position = ( - transform.basis.z * distance) + ( - transform.basis.y * placable.mesh.get_aabb().get_center().y) 


        placable.global_position = lerp(placable.global_position, global_position, delta * sgiConfig.placeMoveSpeed)
        placable.global_rotation.y = lerp_angle(placable.global_rotation.y, global_rotation.y + deg_to_rad(placable.slotData.itemData.orientation) + angle, delta * sgiConfig.placeRotateSpeed)


        if orientationMode == 1:
            placable.global_rotation.x = lerp_angle(placable.global_rotation.x, 0.0, delta * sgiConfig.placeOrientSpeed)
            placable.global_rotation.z = lerp_angle(placable.global_rotation.z, 0.0, delta * sgiConfig.placeOrientSpeed)
        elif orientationMode == 2:
            placable.global_rotation.x = lerp_angle(placable.global_rotation.x, deg_to_rad(-90), delta * sgiConfig.placeOrientSpeed)
            placable.global_rotation.z = lerp_angle(placable.global_rotation.z, 0.0, delta * sgiConfig.placeOrientSpeed)
        elif orientationMode == 3:
            placable.global_rotation.x = lerp_angle(placable.global_rotation.x, 0.0, delta * sgiConfig.placeOrientSpeed)
            placable.global_rotation.z = lerp_angle(placable.global_rotation.z, deg_to_rad(-90), delta * sgiConfig.placeOrientSpeed)


    if gameData.isPlacing && placable && gameData.decor:

        position = ( - transform.basis.z * distance) + ( - transform.basis.y * furniture.mesh.get_aabb().get_center().y)


        var floatingTarget = global_position
        var finalTarget = floatingTarget
        var surfaceOffset = 0.05


        var snapData = furniture.GetSnapData()


        if gameData.magnet && snapData["valid"]:

            var hitPoint = snapData["point"]
            var hitNormal = snapData["normal"]


            if furniture.wallElement:
                var toFloating = floatingTarget - hitPoint
                var distanceFromWall = toFloating.dot(hitNormal)
                finalTarget = (floatingTarget - (hitNormal * distanceFromWall)) + (hitNormal * surfaceOffset)
                var targetRotationRad = atan2(hitNormal.x, hitNormal.z)
                placable.global_rotation.y = lerp_angle(placable.global_rotation.y, targetRotationRad + angle, delta * 10.0)

            else:
                finalTarget = Vector3(floatingTarget.x, hitPoint.y + surfaceOffset, floatingTarget.z)
                placable.global_rotation.y = lerp_angle(placable.global_rotation.y, global_rotation.y + angle, delta * 5.0)


            placable.global_position = lerp(placable.global_position, finalTarget, delta * 20.0)


        else:
            placable.global_rotation.y = lerp_angle(placable.global_rotation.y, global_rotation.y + angle, delta * sgiConfig.placeRotateSpeed)
            placable.global_position = lerp(placable.global_position, floatingTarget, delta * sgiConfig.placeMoveSpeed)
