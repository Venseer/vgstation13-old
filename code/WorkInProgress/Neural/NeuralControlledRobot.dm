/mob/living/silicon/robot/neural_robot
	var/obj/item/device/neural_brain/neural_mmi = null

/mob/living/silicon/robot/neural_robot/show_laws()
	return

/mob/living/silicon/robot/neural_robot/Login()
	to_chat(src, "<b>Welcome to the Nerual-Network interface of [src].</b>")

/mob/living/silicon/robot/neural_robot/proc/usable_brain()
	return !isDead()

/mob/living/silicon/robot/neural_robot/proc/check_avaibility()
	return usable_brain() && neural_mmi.active == 0

/mob/living/silicon/robot/neural_robot/death(gibbed)
	neural_mmi.pod.robot_death()
	..(gibbed)

/mob/living/silicon/robot/neural_robot/gib()
	neural_mmi.pod.robot_death()
	..()
