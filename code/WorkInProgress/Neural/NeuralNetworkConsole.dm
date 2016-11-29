/obj/machinery/computer/neuralconsole
	var/network = "nanotrasen"
	icon_state = "rdcomp"
	var/list/obj/machinery/neural_network_pod/linked_pods = list()
	var/screen = 0.0


/obj/machinery/computer/neuralconsole/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = list("<style>a:link {color: #0066CC} a:visited {color: #0066CC}</style>")
	dat = jointext(dat,"")
	user << browse("<TITLE>Neural Network Console</TITLE><HR>[dat]", "window=neural;size=575x400")
	onclose(user, "neural")
