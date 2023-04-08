::Const.BrassMod.addSettings <- function() {
    // create a page
    local ironmanPage = Brass.Mod.ModSettings.addPage("ironmanPage", "Ironman");
    ironmanPage.addTitle("ironmanSettingsTitle","Ironman Settings");
    ironmanPage.addDivider("ironmanSettingsDivider");
    ironmanPage.addRangeSetting("ironmanSlots", 3, 1, 100, 1, "Ironman slots");
    ironmanPage.addSpacer("ironmanSpacer1", "35rem", "3rem");
    ironmanPage.addBooleanSetting("enableIronmanSlots" ,true,"enable additional Ironman slots");

    ironmanPage.addTitle("bronzemanSettingsTitle","Bronzeman Settings");
    ironmanPage.addDivider("bronzemanSettingsDivider");
    //TODO: BOOL allow ironmal savegaem loading within campain
    //TODO: ENUM show all ironman slots:  disabled / menu / ingame / both
    //TODO: ENUM additional save before Combat: disabled / pre RNG / post RNG / both
    //TODO: BOOL additional save after leave city

    local saveslotPage = Brass.Mod.ModSettings.addPage("saveslotPage", "Saveslots");

    // create a Autosave saveslots
    local autosaveSlider = saveslotPage.addRangeSetting("autosaveSlots", 3, 1, 100, 1,"Autosave Slots");

    // create a Quicksave saveslots
    local quicksaveSlider = saveslotPage.addRangeSetting("quicksaveSlots", 3, 1, 100, 1,"Quicksave Slots");
}