var/global/datum/controller/npcpool/npcpool

/datum/controller/npcpool // This thing pretty much just keeps poking the master controller
	var/processing = 0
	var/processing_interval = 20	//do shit err half second

	var/list/canBeUsed = list()
	var/list/canBeUsed_non = list()
	var/list/needsDelegate = list()
	var/list/needsAssistant = list()
	var/list/needsHelp_non = list()
	var/list/botPool_l = list() //list of all npcs using the pool
	var/list/botPool_l_non = list() //list of all non SNPC mobs using the pool

/datum/controller/npcpool/New()

/datum/controller/npcpool/proc/insertBot(var/toInsert)
	if(istype(toInsert,/mob/living/carbon/human/interactive))
		botPool_l |= toInsert
	else if(istype(toInsert,/obj/machinery/bot))
		botPool_l_non |= toInsert

/datum/controller/npcpool/proc/process()
	processing = 1
	spawn(0)
		set background = BACKGROUND_ENABLED
		while(1)
			//more efficient than recursivly calling ourself over and over. background = 1 ensures we do not trigger an infinite loop
			//bot delegation and coordination systems
			//General checklist/Tasks for delegating a task or coordinating it (for SNPCs)
			// 1. Bot proximity to task target: if too far, delegate, if close, coordinate
			// 2. Bot Health/status: check health with bots in local area, if their health is higher, delegate task to them, else coordinate
			// 3. Process delegation: if a bot (or bots) has been delegated, assign them to the task.
			// 4. Process coordination: if a bot(or bots) has been asked to coordinate, assign them to help.
			// 5. Do all assignments: goes through the delegated/coordianted bots and assigns the right variables/tasks to them.
			var/npcCount = 1
	
			//bot handling
			for(var/obj/machinery/bot/check in botPool_l_non)
				if(!check)
					botPool_l_non.Cut(npcCount,npcCount+1)
	
				if(check.hacked)
					needsHelp_non |= check
				else if(check.frustration > 5) //average for most bots
					needsHelp_non |= check
				else if(check.mode == 0)
					canBeUsed_non |= check
				npcCount++
	
			npcCount = 1 //reset the count
	
			//SNPC handling
			for(var/mob/living/carbon/human/interactive/check in botPool_l)
				var/checkInRange = view(MAX_RANGE_FIND,check)
				if(!check)
					botPool_l.Cut(npcCount,npcCount+1)
				if(!(locate(check.TARGET) in checkInRange))
					needsDelegate |= check
	
				else if(check.isnotfunc(FALSE))
					needsDelegate |= check
	
				else if(check.doing & FIGHTING)
					needsAssistant |= check
	
				else
					canBeUsed |= check
				npcCount++
	
			if(needsDelegate.len)
				for(var/mob/living/carbon/human/interactive/check in needsDelegate)
					if(canBeUsed.len)
						var/mob/living/carbon/human/interactive/candidate = pick(canBeUsed)
						var/facCount = 1
						var/helpProb = 0
						//for(var/C in check.faction) //FIXME
						//	if(candidate.faction[facCount] == C)
						//		helpProb = min(100,helpProb + 25)
						//	facCount++
						if(facCount == 1 && helpProb > 0)
							helpProb = 100
						if(prob(helpProb))
							if(candidate.takeDelegate(check))
								needsDelegate -= check
								canBeUsed -= candidate
								candidate.eye_color = "red"
	
			if(needsAssistant.len)
				for(var/mob/living/carbon/human/interactive/check in needsAssistant)
					if(canBeUsed.len)
						var/mob/living/carbon/human/interactive/candidate = pick(canBeUsed)
						var/facCount = 1
						var/helpProb = 0
						//for(var/C in check.faction) //FIXME
						//	if(candidate.faction[facCount] == C)
						//		helpProb = min(100,helpProb + 10)
						//	facCount++
						if(facCount == 1 && helpProb > 0)
							helpProb = 100
						if(prob(helpProb))
							if(candidate.takeDelegate(check,FALSE))
								needsAssistant -= check
								canBeUsed -= candidate
								candidate.eye_color = "yellow"
	
			if(needsHelp_non.len)
				for(var/obj/machinery/bot/B in needsHelp_non)
					if(canBeUsed_non.len)
						var/obj/machinery/bot/candidate = pick(canBeUsed_non.len)
						candidate.call_bot(B,get_turf(B),FALSE)
						canBeUsed_non -= B
						needsHelp_non -= candidate

			sleep(processing_interval)