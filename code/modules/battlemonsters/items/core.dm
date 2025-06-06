/obj/item/battle_monsters/
	icon = 'icons/obj/battle_monsters/card.dmi'
	icon_state = ""
	var/facedown = TRUE
	var/rotated = FALSE

/obj/item/battle_monsters/dropped(mob/user)
	set_dir(user.dir)
	if(rotated)
		set_dir(turn(dir,90))
	update_icon()
	. = ..()

/obj/item/battle_monsters/pickup(mob/user as mob)
	set_dir(NORTH)
	if(rotated)
		set_dir(turn(dir,90))
	update_icon()
	. = ..()

/obj/item/battle_monsters/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params) //Dropping the card onto something else.
	var/mob/mob_dropped_onto = over
	if(istype(mob_dropped_onto))
		mob_dropped_onto.put_in_active_hand(src)
		src.pickup(mob_dropped_onto)
		return

	. = ..()

/obj/item/battle_monsters/mouse_drop_receive(atom/dropped, mob/user, params) //Dropping C onto the card
	if(istype(dropped, /obj/item/battle_monsters))
		src.attackby(dropped, user)
		return

	. = ..()

/obj/item/battle_monsters/AltClick(var/mob/user)
	RotateCard(user)

/obj/item/battle_monsters/CtrlClick(var/mob/user)
	attack_self(user)

/obj/item/battle_monsters/proc/RotateCard(var/mob/user)

	rotated = !rotated

	if(rotated)
		if(src.loc == user)
			to_chat(user, SPAN_NOTICE("You prepare \the [name] to be played horizontally."))
			set_dir(turn(NORTH,90))
		else
			set_dir(turn(user.dir,90))
			user.visible_message(\
				SPAN_NOTICE("\The [user] adjusts the orientation of \the [src] horizontally."),\
				SPAN_NOTICE("You adjust the orientation of \the [src] horizontally.")\
			)
	else
		if(src.loc == user)
			to_chat(user, SPAN_NOTICE("You prepare \the [name] to be played vertically."))
			set_dir(NORTH)
		else
			set_dir(user.dir)
			user.visible_message(\
				SPAN_NOTICE("\The [user] adjusts the orientation of \the [src] vertically."),\
				SPAN_NOTICE("You adjust the orientation of \the [src] vertically.")\
			)

	update_icon()
