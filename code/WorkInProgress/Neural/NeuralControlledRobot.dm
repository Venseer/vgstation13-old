/mob/living/silicon/robot/neural_robot

/mob/living/silicon/robot/neural_robot/show_laws()
  return

/mob/living/silicon/robot/neural_robot/Login()
  ..()
  to_chat(src, "<b>Welcome to the Nerual-Network interface of [src].</b>")

/mob/living/silicon/robot/neural_robot/check_avaibility()
  return usable_brain() && mmi.active == 0

/mob/living/silicon/robot/neural_robot/usable_brain()
  return !isDead()
