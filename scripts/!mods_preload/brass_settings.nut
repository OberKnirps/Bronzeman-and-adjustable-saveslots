::Const.BrassMod.addSettings <- function() {
    // create a page
    local bronzePage = Brass.Mod.ModSettings.addPage("bronzemanPage", "Bronzeman");
    // create a Bronzeman saveslots
    local bronzemanSlider = bronzePage.addRangeSetting("bronzemanSlots", 3, 1, 100, 1, "Bronzeman Slots");
    local bronzemanToggle = bronzePage.addEnumSetting("bronzeman" , "enabled", ["enabled", "disabled"],"Bronzeman");
    //TODO: Add settings for save conditions (e.g. before/after combat, at Daybreak)

    local saveslotPage = Brass.Mod.ModSettings.addPage("saveslotPage", "Saveslots");

    // create a Autosave saveslots
    local autosaveSlider = saveslotPage.addRangeSetting("autosaveSlots", 3, 1, 100, 1,"Autosave Slots");

    // create a Quicksave saveslots
    local quicksaveSlider = saveslotPage.addRangeSetting("quicksaveSlots", 3, 1, 100, 1,"Quicksave Slots");
}