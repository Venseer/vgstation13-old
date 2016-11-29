var/list/neural_brain_list = list()

/obj/item/device/neural_brain
	name = "\improper Neural-Network Brain"
	w_class = W_CLASS_SMALL
	flags = FPRINT | NOBLUDGEON
	desc = "An artificial brain without intelligence able to recive and send signals used to remote-control synthetic machines."
	var/active = 0
	var/inUse = 0
	var/mob/living/silicon/installedCyborg = null
	var/mob/living/currentUser = null
	var/obj/machinery/neural_network_pod/pod = null
	var/network = "nanotrasen"

/obj/item/device/neural_brain/afterattack(atom/target, mob/user, proximity_flag)
	if(!istype(target, /obj/item/robot_parts/robot_suit))
		return
	var/obj/item/robot_parts/robot_suit/robot = target
	var/turf/T = get_turf(robot)
	if(robot.check_completion())
		if(!istype(T,/turf))
			to_chat(user, "<span class='warning'>You can't put the artificial brain in, the frame has to be standing on the ground to be perfectly precise.</span>")
			return
		var/mob/living/silicon/robot/neural_robot/neural_robot = new /mob/living/silicon/robot/neural_robot(get_turf(target), unfinished = 1)
		neural_robot.invisibility = 0
		neural_robot.custom_name = robot.created_name
		neural_robot.updatename("Default")
		neural_robot.job = "Cyborg"
		neural_robot.cell = robot.chest.cell
		neural_robot.cell.loc = neural_robot
		if(neural_robot.cell)
			var/datum/robot_component/cell_component = neural_robot.components["power cell"]
			cell_component.wrapped = neural_robot.cell
			cell_component.installed = 1
		neural_robot.neural_mmi = src
		installedCyborg = neural_robot
		active = 1
		qdel(robot)
		user.drop_item(src, neural_robot)
		neural_brain_list += src
	else
		to_chat(user, "<span class='notice'>This robot does not seem to be done. You need all parts to be in place in order to insert the artificial brain.</span>")

/obj/item/device/neural_brain/OnMobDeath(var/mob/user)
	if(active && currentUser && pod)
		pod.eject_mob()
	active = 0
	installedCyborg = null
	currentUser = null
