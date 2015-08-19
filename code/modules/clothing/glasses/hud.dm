/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = null //doesn't protect eyes because it's a monocle, duh
	origin_tech = "magnets=3;biotech=2"
	var/hud_type = null

/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	if(slot == slot_glasses)
		var/datum/atom_hud/H = huds[hud_type]
		H.add_hud_to(user)

/obj/item/clothing/glasses/hud/dropped(mob/living/carbon/human/user)
	if(istype(user) && user.glasses == src)
		var/datum/atom_hud/H = huds[hud_type]
		H.remove_hud_from(user)

/obj/item/clothing/glasses/hud/emp_act(severity)
	if(emagged == 0)
		emagged = 1
		desc = desc + " The display flickers slightly."

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	hud_type = DATA_HUD_MEDICAL_ADVANCED

/obj/item/clothing/glasses/hud/health/night
	name = "Night Vision Health Scanner HUD"
	desc = "An advanced medical head-up display that allows doctors to find patients in complete darkness."
	icon_state = "healthhudnight"
	item_state = "glasses"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	hud_type = DATA_HUD_SECURITY_ADVANCED

/obj/item/clothing/glasses/hud/security/attack_self(mob/user)

	var/mob/M = usr
	var/list/options = list()
	options["HUD Sec"] = "sunhud"
	options["Eye Patch Sec"] = "hudpatch"
	options["Gar Sec"] = "gars"

	var/choice = input(M,"To what form do you wish to Morph these Glasses?","Morph Glasses") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "Your HUD has now morphed into [choice]!"
		return 1


/obj/item/clothing/glasses/hud/security/eyepatch
	name = "Eyepatch HUD"
	desc = "A heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "hudpatch"
	flash_protect = 1

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	darkness_view = 1
	flash_protect = 1
	tint = 1

/obj/item/clothing/glasses/hud/security/night
	name = "Night Vision Security HUD"
	desc = "An advanced heads-up display which provides id data and vision in complete darkness."
	icon_state = "securityhudnight"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/security/sunglasses/emp_act(severity)
	if(emagged == 0)
		emagged = 1
		desc = desc + " The display flickers slightly."

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "HUD gar glasses"
	desc = "GAR glasses with a HUD."
	icon_state = "gars"
	item_state = "garb"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars
	name = "giga HUD gar glasses"
	desc = "GIGA GAR glasses with a HUD."
	icon_state = "supergars"
	item_state = "garb"
	force = 18 //Lets buff this shall we?  ~Nexendia
	throwforce = 12


