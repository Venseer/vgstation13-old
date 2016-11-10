/obj/item/device/neural_brain
	name = "\improper Neural-Network Brain"
	w_class = W_CLASS_SMALL
	flags = FPRINT | NOBLUDGEON
	desc = "An artificial brain without intelligence able to recive and send signals used to remote-control synthetic machines."
	var/active = 0
	var/mob/living/silicon/installedCyborg = null
	var/mob/living/currentUser = null

/obj/item/device/neural_brain/afterattack(atom/target, mob/user, proximity_flag)
	if(!istype(target, /obj/item/robot_parts/robot_suit))
		return
	var/obj/item/robot_parts/robot_suit/robot = target
	var/turf/T = get_turf(robot)
	if(robot.check_completion())
		if(!istype(T,/turf))
			to_chat(user, "<span class='warning'>You can't put the artificial brain in, the frame has to be standing on the ground to be perfectly precise.</span>")
			return
		var/mob/living/silicon/robot/neural_robot/nerual_robot = new /mob/living/silicon/robot/neural_robot(get_turf(target), unfinished = 1)
		nerual_robot.invisibility = 0
		nerual_robot.custom_name = robot.created_name
		nerual_robot.updatename("Default")
		nerual_robot.job = "Cyborg"
		nerual_robot.cell = robot.chest.cell
		nerual_robot.cell.loc = nerual_robot
		if(nerual_robot.cell)
			var/datum/robot_component/cell_component = nerual_robot.components["power cell"]
			cell_component.wrapped = nerual_robot.cell
			cell_component.installed = 1
		nerual_robot.mmi = src
		installedCyborg = nerual_robot
		active = 1
		qdel(robot)
		user.drop_item(src, nerual_robot)
	else
		to_chat(user, "<span class='notice'>This robot does not seem to be done. You need all parts to be in place in order to insert the artificial brain.</span>")
