#define POD_BIG_FEEDBACK		30
#define POD_SMALL_FEEDBACK		20

/obj/machinery/neural_network_pod
	name = "Neural-link Control Pod"
	desc = "An enclosed capsule used for remote-control of synthetic machines compatible with the positronic standard."

	icon = 'icons/obj/machines/controller_pod.dmi'
	icon_state = "pod_open"

	density = 1
	anchored = 1

	machine_flags = WRENCHMOVE | FIXED2WORK | EMAGGABLE

	var/mob/living/occupant = null
	var/mob/living/silicon/robot/neural_robot/robot = null

	var/obj/screen/eject_button/eject_button
	var/obj/item/device/neural_reference/reference_occupant

/obj/machinery/neural_network_pod/New()
	..()
	eject_button = new
	eject_button.pod_master = src

/obj/machinery/neural_network_pod/Destroy()
	eject_mob()
	if(robot)
		robot = null
	..()

/obj/machinery/neural_network_pod/wrenchAnchor(mob/user)
	if(occupant)
		user << "You can't move \the [src], it's occupied!"
		return -1
	return ..()

/obj/machinery/neural_network_pod/emag(mob/user)
	if(occupant)
		user.show_message("<span class='danger'>You force \the [src]'s emergency ejection procedures.</span>")
		if(robot)
			occupant.show_message("<span class='danger'>You feel like your brain is being ripped in half.</span>")
			occupant.adjustBrainLoss(POD_BIG_FEEDBACK)
			occupant.Stun(5)
		eject_mob()
		return 1
	return -1

/obj/machinery/neural_network_pod/attack_hand(mob/user)
	if(user == occupant)
		eject_mob()
		return 1
	else if (!occupant)
		enter_mob(user)
		return 1
	return ..()

/obj/machinery/neural_network_pod/Bumped(mob/M)
	if(istype(M, /mob/living) && anchored)
		var/mob/living/L = M
		if(L.dexterity_check() && !occupant)
			enter_mob(L)

/obj/machinery/neural_network_pod/proc/enter_mob(var/mob/living/new_occupant)
	if(!new_occupant || !istype(new_occupant))
		return

	if(!robot)
		new_occupant.show_message("\The [src] beeps: \"No sinal connected!\"", 1)
		return

	//START Adding something to make up for my lack of programming skills
	reference_occupant = new (new_occupant)
	reference_occupant.pod_reference = src
	reference_occupant.mob_reference = new_occupant
	reference_occupant.loc = new_occupant
	//END

	occupant = new_occupant
	new_occupant.forceMove(src)
	icon_state = "pod_closed"

	if(occupant.mind)
		occupant.mind.transfer_to(robot)
		robot.neural_mmi.currentUser = occupant
		robot.neural_mmi.active = 1
		robot.neural_mmi.pod = src

		if(robot.client)
			robot.client.screen.Add(eject_button)
		robot << "<span class='notice'>Neural link successfully established.</span>"
	else
		if(occupant.client)
			occupant.client.screen.Add(eject_button)

/obj/machinery/neural_network_pod/proc/eject_mob()
	for(var/atom/movable/AM in src.contents)
		AM.forceMove(get_turf(src))

	if(robot)
		if(robot.mind && occupant)
			robot.mind.transfer_to(occupant)
			robot.neural_mmi.currentUser = null
			robot.neural_mmi.active = 0

	if(occupant && occupant.client)
		occupant.client.screen.Remove(eject_button)

	qdel(reference_occupant)
	occupant = null
	eject_button.pod_master = src //for some reason the button resets every time you eject
	icon_state = "pod_open"

/obj/machinery/neural_network_pod/proc/robot_death()
	if(occupant)
		occupant.adjustBrainLoss(20)
		robot.show_message("<span class='danger' class='big'>Your neural connection feedbacks!</span>")
		if(robot)
			robot.neural_mmi.active = 0
			robot.neural_mmi.currentUser = null
			robot.neural_mmi.pod = null
		eject_mob()
		robot = null

/obj/machinery/neural_network_pod/proc/connect_brain(var/mob/living/silicon/robot/neural_robot/linked_robot)
	if(!linked_robot || !istype(linked_robot))
		return 0
	if(linked_robot.neural_mmi.active)
		return 0
	robot = linked_robot
	robot.neural_mmi.pod = src
	return 1

/*Eject Button*/

/obj/screen/eject_button
	icon = 'icons/obj/machines/controller_pod.dmi'
	icon_state = "eject_button"
	screen_loc = "14:0,14:16"

	var/obj/machinery/neural_network_pod/pod_master = null

/obj/screen/eject_button/Click()
	if(pod_master)
		pod_master.eject_mob()

/*Neural Reference*/
/*HAAAAAAAAACKS :^)*/
/obj/item/device/neural_reference
	var/obj/machinery/neural_network_pod/pod_reference = null
	var/mob/living/mob_reference = null

/obj/item/device/neural_reference/process()
	if(src.loc != mob_reference)
		qdel(src)

/obj/item/device/neural_reference/OnMobDeath(var/mob/M)
	if(src.pod_reference.occupant && src.mob_reference == src.pod_reference.occupant)
		src.pod_reference.eject_mob()
