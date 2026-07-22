Config = {}

Config.MaxDistance = 50.0
Config.Collisions = true
Config.RequireAdmin = false
Config.AcePerms = "" -- Added your ACE permission 

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
    Roll = 'Flèches'
}

Config.Filters = {
    { label = "Aucun", value = "none" },
    { label = "Noir et blanc", value = "spectator4" },
    { label = "Caméra de sécurité", value = "CAMERA_secuirity_FUZZ" },
    { label = "Luminosité", value = "BeastLaunch02" },
    { label = "Focus central", value = "AirRaceBoost01" },
    { label = "Effet vert", value = "AirRaceBoost02" },
    { label = "Netteté", value = "AmbientPUSH" },
    { label = "Vieux violet", value = "ArenaEMP" },
    { label = "Vieux bleu clair", value = "ArenaEMP_Blend" },
    { label = "Vieux marron", value = "BeastIntro01" },
    { label = "Vieux rouge", value = "BeastIntro02" },
    { label = "Plage classique", value = "ArenaWheelPurple01" },
    { label = "Plage ensoleillée", value = "ArenaWheelPurple02" },
    { label = "Profondeur", value = "Bank_HLWD" },
    { label = "420 (Défoncé)", value = "Barry1_Stoned" },
    { label = "Trop de drogues", value = "BikerFilter" },
    { label = "Flou fondu", value = "BarryFadeOut" },
    { label = "Ombre sur les bords", value = "BikerForm01" },
    { label = "Film mexicain (Clair)", value = "Bikers" },
    { label = "Film mexicain (Sombre)", value = "BikersSPLASH" },
    { label = "Vert avec lignes", value = "blackNwhite" },
    { label = "Flou sale", value = "BlackOut" },
    { label = "Chaleur rose", value = "BleepYellow02" },
    { label = "Éclat intense (Bloom)", value = "Bloom" },
    { label = "Éclat moyen", value = "BloomLight" },
    { label = "Éclat léger", value = "BloomMid" },
    { label = "Vieille TV", value = "Broken_camera_fuzz" },
    { label = "Bleu intense", value = "BulletTimeDark" },
    { label = "Rouge intense", value = "casino_managersoffice" },
    { label = "Jour et Nuit", value = "casino_mainfloor" },
    { label = "Vieille Caméra", value = "CHOP" },
    { label = "Cinéma (Léger)", value = "cinema" },
    { label = "Cinéma (Intense)", value = "cinema_001" },
    { label = "Noir & Blanc avec éclat", value = "cops" },
    { label = "Touche violette", value = "CopsSPLASH" },
    { label = "Touche orange", value = "CrossLine01" },
    { label = "Fond propre", value = "CS1_railwayB_tunnel" },
    { label = "Sans lumière", value = "downtown_FIB_cascades_opt" },
    { label = "Ombre rouge", value = "damage" },
    { label = "Ciel lumineux", value = "dlc_casino_carpark" },
    { label = "Reflets jaunes", value = "DrivingFocusLight" },
    { label = "Reflets verts", value = "DrivingFocusDark" },
    { label = "Gouttes bleues", value = "DRUG_2_drive" },
    { label = "Gouttes violettes", value = "drug_drive_blend02" },
    { label = "Sous l'eau", value = "Drug_deadman" },
    { label = "Vert pur", value = "drug_flying_02" },
    { label = "Rose pur", value = "drug_flying_base" },
    { label = "Plus de lumières", value = "eatra_bouncelight_beach" },
    { label = "Contraste", value = "epsilion" },
    { label = "Contraste 2", value = "exile1_plane" },
    { label = "Lumières vives", value = "Facebook_NEW" },
    { label = "Lumières vives 2", value = "facebook_serveroom" },
    { label = "Lumières vives 3", value = "FIB_5" },
    { label = "Lumières vives 4", value = "FIB_6" },
    { label = "Lumières vives 5", value = "FIB_A" },
    { label = "Lumières vives 6", value = "FIB_B" },
    { label = "Ombre avec flou", value = "fp_vig_blue" },
    { label = "Ombre verte avec flou", value = "fp_vig_green" },
    { label = "Teinte verte", value = "FranklinColorCode" },
    { label = "Teinte verte 2", value = "FranklinColorCodeBasic" },
    { label = "Teinte verte 3", value = "FranklinColorCodeBright" },
    { label = "Couleurs froides", value = "Glasses_BlackOut" },
    { label = "Couleurs froides 2", value = "glasses_brown" },
    { label = "Teinte bleue", value = "glasses_Darkblue" },
    { label = "Teinte verte sombre", value = "glasses_green" },
    { label = "Teinte orange", value = "glasses_orange" },
    { label = "Teinte rose", value = "glasses_pink" },
    { label = "Teinte violette", value = "glasses_purple" },
    { label = "Teinte rouge", value = "glasses_red" },
    { label = "Orange et vert", value = "glasses_yellow" },
    { label = "Brouillard (Fog)", value = "graveyard_shootout" },
    { label = "Ombre floue", value = "helicamfirst" },
    { label = "Rouge et bleu", value = "Hint_cam" },
    { label = "Bleu clair", value = "hud_def_colorgrade" },
    { label = "Noir & Blanc 2", value = "hud_def_desat_cold_kill" },
    { label = "Noir & Blanc 3", value = "hud_def_desatcrunch" },
    { label = "Plage douce", value = "InchPurple01" },
    { label = "Blanc et bleu clair", value = "int_Hospital2_DM" },
    { label = "Noir et bleu", value = "introblue" },
    { label = "Flou violet", value = "Kifflom" },
    { label = "Fond estompé", value = "michealspliff" },
    { label = "Ciel clair", value = "MP_Arena_theme_atlantis" },
    { label = "Ciel jaune", value = 'MP_Arena_theme_evening' },
    { label = "Projecteur bleu", value = "mp_lad_day" },
    { label = "Projecteur rouge", value = "mp_lad_judgment" },
    { label = "Smog", value = "nervousRON_fog" },
    { label = "Noir & Blanc 4", value = "NG_blackout" },
    { label = "Noir & Blanc 5", value = "NG_deathfail_BW_base" },
    { label = "Couleurs chaudes", value = "NG_filmic10" },
    { label = "Noir & Blanc 6", value = "phone_cam7" },
    { label = "Brouillard sombre", value = "SALTONSEA" },
    { label = "Brouillard sombre 2", value = "WATER_cove" },
    { label = "Sous l'eau 2", value = "underwater_deep" },
    { label = "Rose doux", value = "TinyPink01" }
}
