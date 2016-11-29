/mob/living/silicon/robot/neural_robot
	var/obj/item/device/neural_brain/neural_mmi = null

/mob/living/silicon/robot/neural_robot/show_laws()
	return

/mob/living/silicon/robot/neural_robot/Login()
	..()
	to_chat(src, "<b>Welcome to the Neural-Network interface of [src].</b>")

/mob/living/silicon/robot/neural_robot/proc/usable_brain()
	return !isDead()

/mob/living/silicon/robot/neural_robot/death(gibbed)
	neural_mmi.pod.robot_death()
	..(gibbed)

/mob/living/silicon/robot/neural_robot/gib()
	neural_mmi.pod.robot_death()
	..()

/mob/living/silicon/robot/neural_robot/New(loc,var/syndie = 0,var/unfinished = 0,var/startup_sound=null)
	..(loc,syndie,unfinished,startup_sound)
	laws = null
	if(connected_ai)
		connected_ai.connected_robots -= src
		connected_ai = null
		lawupdate = 0
