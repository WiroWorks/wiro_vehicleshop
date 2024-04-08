Config                            = {}


-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.minCarFactoryHour = 3
Config.maxCarFactoryHour = 24


Config.BetterBank = true  -- !!REMAKE VERSİON!! If you want to use betterbank in this script make this true else false

-- https://youtu.be/n9rlYjRMpIM | little tutorial for creating new vehicleshops
Config.vehicleShops = { -- !!! WARNING job Names always must be like dealer1, dealer2, dealer3 or script doesn't gonna work
    [1] = {
        jobName = "dealer1", -- Don't forget to add in to the database jobs table and create job_grades {grade = 0, name = "employee"} {grade = 1, name = "boss"}
        deafultName = "Vehicle Shop 1",
        IBAN = "WRVS11",  -- IBAN is can't change able after first start
        buyPrice = 750000,
        resellPrice = 500000
    },
    [2] = {
        jobName = "dealer2", -- Don't forget to add in to the database jobs table and create job_grades {grade = 0, name = "employee"} {grade = 1, name = "boss"}
        deafultName = "Vehicle Shop 2",
        IBAN = "WRVS12",  -- IBAN is can't change able after first start
        buyPrice = 750000,
        resellPrice = 500000
    }
}

Config.Markers = {
    [1] = { -- open shop
        coords = vector3(228.36, -988.9, -99.97),
		other = {type = 25, size = {x = 1.0, y = 1.0, z = 1.0}, rgb = {r = 255, g = 0, b = 0, a = 100}},
        message = "See the vehicles ~INPUT_CONTEXT~"
    },
    [2] = { -- tp to 3
        coords = vector3(-50.24, -1089.51, 25.43),
		other = {type = 25, size = {x = 1.0, y = 1.0, z = 1.0}, rgb = {r = 255, g = 255, b = 0, a = 100}},
        message = "Go to vehicle room ~INPUT_CONTEXT~",
        blip = {sprite = 595, scale = 1.0, color = 1, text = "Galery"}
    },
	[3] = { -- tp to 2
		coords = vector3(240.57, -1004.94, -99.97),
		other = {type = 25, size = {x = 1.0, y = 1.0, z = 1.0}, rgb = {r = 255, g = 255, b = 0, a = 100}},
        message = "Go to Store ~INPUT_CONTEXT~"
	},
    [4] = { -- test ride spawn and return marker
        coords = vector3(-49.64, -1080.15, 25.87),
		other = {type = 25, size = {x = 2.5, y = 2.5, z = 1.0}, rgb = {r = 255, g = 0, b = 0, a = 100}},
        message = "Return the test ride vehicle ~INPUT_CONTEXT~"
    },
    [5] = { -- buyable dealer shops
        coords = vector3(-29.84, -1104.15, 25.50),
        other = {type = 25, size = {x = 1.5, y = 1.5, z = 1.0}, rgb = {r = 255, g = 255, b = 0, a = 100}},
        message = "Open buyable dealer shops menu ~INPUT_CONTEXT~"
    },
    [6] = { -- take able vehicles (Factory)
        coords = vector3(1180.6, -3113.76, 5.04),
        other = {type = 25, size = {x = 1.5, y = 1.5, z = 1.0}, rgb = {r = 255, g = 0, b = 0, a = 200}},
        message = "Open takeable vehicles menu ~INPUT_CONTEXT~",
        requestDealer = "dealer", -- don't change this,
        blip = {sprite = 211, scale = 1.0, color = 0, text = "Factory"}
    }, -- BE careful after that because everything is about dealer's markes
    [7] = { -- dealer1 marker
        coords = vector3(211.83, -183.85, 53.61),
        other = {type = 25, size = {x = 1.5, y = 1.5, z = 1.0}, rgb = {r = 255, g = 0, b = 0, a = 200}},
        message = "Open Dealer menu ~INPUT_CONTEXT~",
        requestJob = "dealer1" ,
        blip = {sprite = 595, scale = 1.0, color = 1, text = "Galery"}
    },
    [8] = { -- dealer1 marker
    coords = vector3(116.83, -188.85, 53.61),
    other = {type = 25, size = {x = 1.5, y = 1.5, z = 1.0}, rgb = {r = 255, g = 0, b = 0, a = 200}},
    message = "Open Dealer menu ~INPUT_CONTEXT~",
    requestJob = "dealer2" ,
    blip = {sprite = 595, scale = 1.0, color = 1, text = "Galery"} -- text doesn't matter
    }
}

Config.factoryVehicleSpawns = {
    [1] = {coord = vector3(1155.67, -3126.28, 6.0), heading = 180.0},
    [2] = {coord = vector3(1152.67, -3126.28, 6.0), heading = 180.0},
    [3] = {coord = vector3(1149.67, -3126.28, 6.0), heading = 180.0},
    [4] = {coord = vector3(1146.67, -3126.28, 6.0), heading = 180.0},
}

Config.TestRide = {
    enable = true, -- is test ride active
    time = 30,  -- sec
    canExitCar = false,
    alertMessageRadius = 100.0, -- if player-return place distance more than this number send alert message
    stopTestRideRadius = 300.0 -- if player-return place distance more than this number test ride will end
}

Config.Language = {
    keepYourDistance = "Keep your distance",
    maxDistance = "If you go more far test ride will end",
    timeLimit = "Your test ride started your time limit is %d second",
    testRide = "Test ride",
    youAreDealer = "You already have a vehicleshop",
    noPermission = "you don't have permission to do that",
    vehicles = "Vehicles",
    back = "Back",
    sure = "Are you sure ?",
    yes = "Yes",
    no = "No",
    price = "Price :",
    carBuyed = "The order has been placed, you can track the order from the office.",
    notEnoghtMoney = "Your company balance is not enoght!",
    notEnoghtMoneyPlayer = "You doesn't have enoght money in your bank!",
    noStock = "There is no stock for this car",
    buyableShops = "Buyable vehicleshops",
    vehicleLoading = "Vehicle model is loading please wait",
    success = "Success",
    error = "Error",
    vehicle = "Vehicle"
}

Config.ColorNames = {
    [0] = "Metallic Black",
    [1] = "Metallic Graphite Black",
    [2] = "Metallic Black Steal",
    [3] = "Metallic Dark Silver",
    [4] = "Metallic Silver",
    [5] = "Metallic Blue Silver",
    [6] = "Metallic Steel Gray",
    [7] = "Metallic Shadow Silver",
    [8] = "Metallic Stone Silver",
    [9] = "Metallic Midnight Silver",
    [10] = "Metallic Gun Metal",
    [11] = "Metallic Anthracite Grey",
    [12] = "Matte Black",
    [13] = "Matte Gray",
    [14] = "Matte Light Grey",
    [15] = "Util Black",
    [16] = "Util Black Poly",
    [17] = "Util Dark silver",
    [18] = "Util Silver",
    [19] = "Util Gun Metal",
    [20] = "Util Shadow Silver",
    [21] = "Worn Black",
    [22] = "Worn Graphite",
    [23] = "Worn Silver Grey",
    [24] = "Worn Silver",
    [25] = "Worn Blue Silver",
    [26] = "Worn Shadow Silver",
    [27] = "Metallic Red",
    [28] = "Metallic Torino Red",
    [29] = "Metallic Formula Red",
    [30] = "Metallic Blaze Red",
    [31] = "Metallic Graceful Red",
    [32] = "Metallic Garnet Red",
    [33] = "Metallic Desert Red",
    [34] = "Metallic Cabernet Red",
    [35] = "Metallic Candy Red",
    [36] = "Metallic Sunrise Orange",
    [37] = "Metallic Classic Gold",
    [38] = "Metallic Orange",
    [39] = "Matte Red",
    [40] = "Matte Dark Red",
    [41] = "Matte Orange",
    [42] = "Matte Yellow",
    [43] = "Util Red",
    [44] = "Util Bright Red",
    [45] = "Util Garnet Red",
    [46] = "Worn Red",
    [47] = "Worn Golden Red",
    [48] = "Worn Dark Red",
    [49] = "Metallic Dark Green",
    [50] = "Metallic Racing Green",
    [51] = "Metallic Sea Green",
    [52] = "Metallic Olive Green",
    [53] = "Metallic Green",
    [54] = "Metallic Gasoline Blue Green",
    [55] = "Matte Lime Green",
    [56] = "Util Dark Green",
    [57] = "Util Green",
    [58] = "Worn Dark Green",
    [59] = "Worn Green",
    [60] = "Worn Sea Wash",
    [61] = "Metallic Midnight Blue",
    [62] = "Metallic Dark Blue",
    [63] = "Metallic Saxony Blue",
    [64] = "Metallic Blue",
    [65] = "Metallic Mariner Blue",
    [66] = "Metallic Harbor Blue",
    [67] = "Metallic Diamond Blue",
    [68] = "Metallic Surf Blue",
    [69] = "Metallic Nautical Blue",
    [70] = "Metallic Bright Blue",
    [71] = "Metallic Purple Blue",
    [72] = "Metallic Spinnaker Blue",
    [73] = "Metallic Ultra Blue",
    [74] = "Metallic Bright Blue",
    [75] = "Util Dark Blue",
    [76] = "Util Midnight Blue",
    [77] = "Util Blue",
    [78] = "Util Sea Foam Blue",
    [79] = "Uil Lightning blue",
    [80] = "Util Maui Blue Poly",
    [81] = "Util Bright Blue",
    [82] = "Matte Dark Blue",
    [83] = "Matte Blue",
    [84] = "Matte Midnight Blue",
    [85] = "Worn Dark blue",
    [86] = "Worn Blue",
    [87] = "Worn Light blue",
    [88] = "Metallic Taxi Yellow",
    [89] = "Metallic Race Yellow",
    [90] = "Metallic Bronze",
    [91] = "Metallic Yellow Bird",
    [92] = "Metallic Lime",
    [93] = "Metallic Champagne",
    [94] = "Metallic Pueblo Beige",
    [95] = "Metallic Dark Ivory",
    [96] = "Metallic Choco Brown",
    [97] = "Metallic Golden Brown",
    [98] = "Metallic Light Brown",
    [99] = "Metallic Straw Beige",
    [100] = "Metallic Moss Brown",
    [101] = "Metallic Biston Brown",
    [102] = "Metallic Beechwood",
    [103] = "Metallic Dark Beechwood",
    [104] = "Metallic Choco Orange",
    [105] = "Metallic Beach Sand",
    [106] = "Metallic Sun Bleeched Sand",
    [107] = "Metallic Cream",
    [108] = "Util Brown",
    [109] = "Util Medium Brown",
    [110] = "Util Light Brown",
    [111] = "Metallic White",
    [112] = "Metallic Frost White",
    [113] = "Worn Honey Beige",
    [114] = "Worn Brown",
    [115] = "Worn Dark Brown",
    [116] = "Worn straw beige",
    [117] = "Brushed Steel",
    [118] = "Brushed Black steel",
    [119] = "Brushed Aluminium",
    [120] = "Chrome",
    [121] = "Worn Off White",
    [122] = "Util Off White",
    [123] = "Worn Orange",
    [124] = "Worn Light Orange",
    [125] = "Metallic Securicor Green",
    [126] = "Worn Taxi Yellow",
    [127] = "police car blue",
    [128] = "Matte Green",
    [129] = "Matte Brown",
    [130] = "Worn Orange",
    [131] = "Matte White",
    [132] = "Worn White",
    [133] = "Worn Olive Army Green",
    [134] = "Pure White",
    [135] = "Hot Pink",
    [136] = "Salmon pink",
    [137] = "Metallic Vermillion Pink",
    [138] = "Orange",
    [139] = "Green",
    [140] = "Blue",
    [141] = "Mettalic Black Blue",
    [142] = "Metallic Black Purple",
    [143] = "Metallic Black Red",
    [144] = "hunter green",
    [145] = "Metallic Purple",
    [146] = "Metaillic V Dark Blue",
    [147] = "MODSHOP BLACK1",
    [148] = "Matte Purple",
    [149] = "Matte Dark Purple",
    [150] = "Metallic Lava Red",
    [151] = "Matte Forest Green",
    [152] = "Matte Olive Drab",
    [153] = "Matte Desert Brown",
    [154] = "Matte Desert Tan",
    [155] = "Matte Foilage Green",
    [156] = "DEFAULT ALLOY COLOR",
    [157] = "Epsilon Blue",
}