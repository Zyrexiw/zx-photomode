Config = {}

Config.MaxDistance = 50.0
Config.Collisions = true
Config.RequireAdmin = false

Config.MoveSpeed     = 5.0
Config.FastMoveSpeed = 15.0
Config.RotateSpeed   = 3.0
Config.ZoomSpeed     = 0.5
Config.MoveSmoothing = 6.0
Config.ZoomSmoothing = 5.0

Config.MinFov = 10.0
Config.MaxFov = 90.0
Config.DefaultFov = 50.0

Config.TransitionDefaultTime = 5000

Config.MarkerSize = { x = 0.8, y = 0.8, z = 0.8 }
Config.MarkerColor = { r = 220, g = 30, b = 30, a = 200 }

Config.Controls = {
    ToggleFreecam      = nil,
    FastMove           = 21,
    MoveUp             = 44,
    MoveDown           = 51,
    SetTransitionPoint = 47,
    ZoomIn             = 241,
    ZoomOut            = 242,
    ToggleUI           = 311,
    RollLeft           = 174,
    RollRight          = 175,
}

Config.Keys = {
    Forward = 'Z',
    Backward = 'S',
    Left = 'Q',
    Right = 'D',
    Up = 'A',
    Down = 'E',
    Speed = 'Shift',
    SetPoint = 'O',
    ToggleUI = 'K',
    Quit = 'F2',
    Roll = 'Arrow'
}

Config.Filters = {
    { label = "None", value = "none" },
    { label = "Black & White", value = "spectator4" },
    { label = "Security Camera", value = "CAMERA_secuirity_FUZZ" },
    { label = "Brightness", value = "BeastLaunch02" },
    { label = "Central Focus", value = "AirRaceBoost01" },
    { label = "Green Effect", value = "AirRaceBoost02" },
    { label = "Sharpness", value = "AmbientPUSH" },
    { label = "Old Purple", value = "ArenaEMP" },
    { label = "Old Light Blue", value = "ArenaEMP_Blend" },
    { label = "Old Brown", value = "BeastIntro01" },
    { label = "Old Red", value = "BeastIntro02" },
    { label = "Classic Beach", value = "ArenaWheelPurple01" },
    { label = "Sunny Beach", value = "ArenaWheelPurple02" },
    { label = "Depth", value = "Bank_HLWD" },
    { label = "420 (High)", value = "Barry1_Stoned" },
    { label = "Too Much Drugs", value = "BikerFilter" },
    { label = "Fade Blur", value = "BarryFadeOut" },
    { label = "Edge Shadow", value = "BikerForm01" },
    { label = "Mexican Movie (Light)", value = "Bikers" },
    { label = "Mexican Movie (Dark)", value = "BikersSPLASH" },
    { label = "Green With Lines", value = "blackNwhite" },
    { label = "Dirty Blur", value = "BlackOut" },
    { label = "Pink Warmth", value = "BleepYellow02" },
    { label = "Strong Glow (Bloom)", value = "Bloom" },
    { label = "Medium Glow", value = "BloomLight" },
    { label = "Light Glow", value = "BloomMid" },
    { label = "Old TV", value = "Broken_camera_fuzz" },
    { label = "Intense Blue", value = "BulletTimeDark" },
    { label = "Intense Red", value = "casino_managersoffice" },
    { label = "Day & Night", value = "casino_mainfloor" },
    { label = "Old Camera", value = "CHOP" },
    { label = "Cinema (Light)", value = "cinema" },
    { label = "Cinema (Intense)", value = "cinema_001" },
    { label = "Black & White With Glow", value = "cops" },
    { label = "Purple Tint", value = "CopsSPLASH" },
    { label = "Orange Tint", value = "CrossLine01" },
    { label = "Clean Background", value = "CS1_railwayB_tunnel" },
    { label = "No Light", value = "downtown_FIB_cascades_opt" },
    { label = "Red Shadow", value = "damage" },
    { label = "Bright Sky", value = "dlc_casino_carpark" },
    { label = "Yellow Reflections", value = "DrivingFocusLight" },
    { label = "Green Reflections", value = "DrivingFocusDark" },
    { label = "Blue Drops", value = "DRUG_2_drive" },
    { label = "Purple Drops", value = "drug_drive_blend02" },
    { label = "Underwater", value = "Drug_deadman" },
    { label = "Pure Green", value = "drug_flying_02" },
    { label = "Pure Pink", value = "drug_flying_base" },
    { label = "More Lights", value = "eatra_bouncelight_beach" },
    { label = "Contrast", value = "epsilion" },
    { label = "Contrast 2", value = "exile1_plane" },
    { label = "Bright Lights", value = "Facebook_NEW" },
    { label = "Bright Lights 2", value = "facebook_serveroom" },
    { label = "Bright Lights 3", value = "FIB_5" },
    { label = "Bright Lights 4", value = "FIB_6" },
    { label = "Bright Lights 5", value = "FIB_A" },
    { label = "Bright Lights 6", value = "FIB_B" },
    { label = "Blurred Shadow", value = "fp_vig_blue" },
    { label = "Green Blurred Shadow", value = "fp_vig_green" },
    { label = "Green Tint", value = "FranklinColorCode" },
    { label = "Green Tint 2", value = "FranklinColorCodeBasic" },
    { label = "Green Tint 3", value = "FranklinColorCodeBright" },
    { label = "Cold Colors", value = "Glasses_BlackOut" },
    { label = "Cold Colors 2", value = "glasses_brown" },
    { label = "Blue Tint", value = "glasses_Darkblue" },
    { label = "Dark Green Tint", value = "glasses_green" },
    { label = "Orange Tint", value = "glasses_orange" },
    { label = "Pink Tint", value = "glasses_pink" },
    { label = "Purple Tint", value = "glasses_purple" },
    { label = "Red Tint", value = "glasses_red" },
    { label = "Orange & Green", value = "glasses_yellow" },
    { label = "Fog", value = "graveyard_shootout" },
    { label = "Blurred Shadow", value = "helicamfirst" },
    { label = "Red & Blue", value = "Hint_cam" },
    { label = "Light Blue", value = "hud_def_colorgrade" },
    { label = "Black & White 2", value = "hud_def_desat_cold_kill" },
    { label = "Black & White 3", value = "hud_def_desatcrunch" },
    { label = "Soft Beach", value = "InchPurple01" },
    { label = "White & Light Blue", value = "int_Hospital2_DM" },
    { label = "Black & Blue", value = "introblue" },
    { label = "Purple Blur", value = "Kifflom" },
    { label = "Faded Background", value = "michealspliff" },
    { label = "Clear Sky", value = "MP_Arena_theme_atlantis" },
    { label = "Yellow Sky", value = "MP_Arena_theme_evening" },
    { label = "Blue Spotlight", value = "mp_lad_day" },
    { label = "Red Spotlight", value = "mp_lad_judgment" },
    { label = "Smog", value = "nervousRON_fog" },
    { label = "Black & White 4", value = "NG_blackout" },
    { label = "Black & White 5", value = "NG_deathfail_BW_base" },
    { label = "Warm Colors", value = "NG_filmic10" },
    { label = "Black & White 6", value = "phone_cam7" },
    { label = "Dark Fog", value = "SALTONSEA" },
    { label = "Dark Fog 2", value = "WATER_cove" },
    { label = "Underwater 2", value = "underwater_deep" },
    { label = "Soft Pink", value = "TinyPink01" }
}