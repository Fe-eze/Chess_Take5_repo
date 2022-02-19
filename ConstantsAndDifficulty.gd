extends Node

# preload the register submenu popup
var RegisterScene = preload("res://RegisterSubMenu.tscn")
var new_reg

const HIGHEST_POSSIBLE_CHESS_SCORE = 3000
const DIFFICULTY_LEVELS = {
	"Total Beginner" : {
		"Commentary" : "You are trying to get into chess for the first time and have zero experience", 
		"Range": [0, 400], 
		"DefaultScore": 250
		},
	"Novice": {
		"Commentary": "You know a bit about chess but are still a beginner", 
		"Range": [401, 850], 
		"DefaultScore": 600
		},
	"Lower Intermediate" : {
		"Commentary": "", 
		"Range": [851, 1200], 
		"DefaultScore": 1000
	},
	"Upper Intermediate" : {
		"Commentary": "", 
		"Range": [1201, 1600], 
		"DefaultScore": 1400
	},
	"Competent" : {
		"Commentary": "", 
		"Range": [1601, 2000], 
		"DefaultScore": 1800
	},
	"Expert" : {
		"Commentary": "", 
		"Range": [2001, 2450], 
		"DefaultScore": 2200
	},
	"Grandmaster" : {
		"Commentary": "", 
		"Range": [2451, 3000], 
		"DefaultScore": 2800
	}
}
