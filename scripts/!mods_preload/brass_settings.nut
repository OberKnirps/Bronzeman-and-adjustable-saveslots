::Const.BrassMod.addSettings <- function() {
    //create a page
    local ironmanPage = Brass.Mod.ModSettings.addPage("ironmanPage", "Ironman");
    ironmanPage.addTitle("ironmanSettingsTitle","Ironman Settings");
    ironmanPage.addDivider("ironmanSettingsDivider");

    local t = ironmanPage.addRangeSetting("ironmanSlots", 3, 1, 100, 1, "Ironman slots");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addSpacer("ironmanSpacer1", "35rem", "3rem");
    t.Data.NewCampaign <- true;

    //BOOL enable additional ironman slots
    local t = ironmanPage.addBooleanSetting("enableIronmanSlots" ,true,"Enable additional Ironman slots");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //BOOL hide additional ironman slots
    local t = ironmanPage.addBooleanSetting("hideAdditionalIronmanSlots", true, "Hide additional Ironman slots");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addTitle("bronzemanSettingsTitle","Bronzeman Settings");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addDivider("bronzemanSettingsDivider");
    t.Data.NewCampaign <- true;

    //ENUM show ironman slots:  disabled / menu / ingame / both
    local t = ironmanPage.addEnumSetting("showIronmanSaves", "Menu", ["Disabled", "Menu", "Ingame", "Both"], "Show Ironman saves");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //ENUM show bronzeman slots:  disabled / menu / ingame / both
    local t = ironmanPage.addEnumSetting("showBronzeSaves", "Disabled", ["Disabled", "Menu", "Ingame", "Both"], "Show Bronzeman saves");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //BOOL additional save before Combat
    local t = ironmanPage.addBooleanSetting("saveBeforeCombat", false, "Pre combat save");
    t.setDescription("Additional saves before Combat");
    t.Data.NewCampaign <- true;

    //BOOL additional save after Combat
    local t = ironmanPage.addBooleanSetting("saveAfterCombat", false, "Post combat save");
    t.setDescription("Additional save after finishing Combat");
    t.Data.NewCampaign <- true;

    //BOOL additional save on entering settlment
    local t = ironmanPage.addBooleanSetting("saveEnterSettlement", false, "Save before entering Settlement");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //BOOL additional save on leaving settlment
    local t = ironmanPage.addBooleanSetting("saveLeaveSettlement", false, "Save after leaving Settlement");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    local saveslotPage = Brass.Mod.ModSettings.addPage("saveslotPage", "Saveslots");

    //create a Autosave saveslots
    local t = saveslotPage.addRangeSetting("autosaveSlots", 3, 1, 100, 1,"Autosave Slots");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //create a Quicksave saveslots
    local t = saveslotPage.addRangeSetting("quicksaveSlots", 3, 1, 100, 1,"Quicksave Slots");
    t.setDescription("TBD");
    t.Data.NewCampaign <- true;
}