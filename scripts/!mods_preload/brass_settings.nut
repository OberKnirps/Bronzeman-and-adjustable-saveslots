::Const.BrassMod.addSettings <- function() {
    //create a page
    local ironmanPage = Brass.Mod.ModSettings.addPage("ironmanPage", "Ironman");
    ironmanPage.addTitle("ironmanSettingsTitle","Ironman Settings");
    ironmanPage.addDivider("ironmanSettingsDivider");

    local t = ironmanPage.addRangeSetting("ironmanSlots", 3, 1, 100, 1, "Ironman slots");
    t.setDescription("Number of additional ironman savegames");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addSpacer("ironmanSpacer1", "35rem", "3rem");
    t.Data.NewCampaign <- true;

    //BOOL enable additional ironman slots
    local t = ironmanPage.addBooleanSetting("enableIronmanSlots" ,true,"Enable additional Ironman slots");
    //t.setDescription("TBD");
    t.Data.NewCampaign <- true;

    //BOOL hide additional ironman slots
    local t = ironmanPage.addBooleanSetting("hideAdditionalIronmanSlots", true, "Hide additional Ironman slots");
    t.setDescription("Shows only the newest savegame per ironman campaign, but still makes multiple savegames if they are not diabled.");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addTitle("bronzemanSettingsTitle","Bronzeman Settings");
    t.Data.NewCampaign <- true;

    local t = ironmanPage.addDivider("bronzemanSettingsDivider");
    t.Data.NewCampaign <- true;

    //ENUM show ironman slots:  disabled / menu / ingame / both
    local t = ironmanPage.addEnumSetting("showIronmanSaves", "Menu", ["Disabled", "Menu", "Ingame", "Both"], "Show Ironman saves");
    t.setDescription("Disabled - no ironman savegames will be shown anywhere\n Menu(default) - ironman savegames will be shown in main menu or for campaigns you are not currently playing \n Ingame - ironman savegames will only be shown for the campaign you are currently in (you CAN'T load from the main menu)\n Both - ironman savegames will be shown in any loading screen");

    t.Data.NewCampaign <- true;

    //ENUM show bronzeman slots:  disabled / menu / ingame / both
    local t = ironmanPage.addEnumSetting("showBronzeSaves", "Disabled", ["Disabled", "Menu", "Ingame", "Both"], "Show Bronzeman saves");
    t.setDescription("Disabled - no bronzeman savegames will be shown anywhere\n Menu - bronzeman savegames will be shown in main menu or for campaigns you are not currently playing \n Ingame - bronzeman savegames will only be shown for the campaign you are currently in (you CAN'T load from the main menu)\n Both - bronzeman savegames will be shown in any loading screen");
    t.Data.NewCampaign <- true;

    //BOOL additional save before Combat
    local t = ironmanPage.addBooleanSetting("saveBeforeCombat", false, "Pre combat save");
    t.setDescription("Additional saves before combat");
    t.Data.NewCampaign <- true;

    //BOOL additional save after Combat
    local t = ironmanPage.addBooleanSetting("saveAfterCombat", false, "Post combat save");
    t.setDescription("Additional save after finishing combat");
    t.Data.NewCampaign <- true;

    //BOOL additional save on entering settlment
    local t = ironmanPage.addBooleanSetting("saveEnterSettlement", false, "Save before entering Settlement");
    t.setDescription("Additional saves before entering settlement");
    t.Data.NewCampaign <- true;

    //BOOL additional save on leaving settlment
    local t = ironmanPage.addBooleanSetting("saveLeaveSettlement", false, "Save after leaving Settlement");
    t.setDescription("Additional save after leaving settlement");
    t.Data.NewCampaign <- true;

    local saveslotPage = Brass.Mod.ModSettings.addPage("saveslotPage", "Saveslots");

    //create a Autosave saveslots
    local t = saveslotPage.addRangeSetting("autosaveSlots", 3, 1, 100, 1,"Autosave Slots");
    t.setDescription("Number of additional autosaves");
    t.Data.NewCampaign <- true;

    //create a Quicksave saveslots
    local t = saveslotPage.addRangeSetting("quicksaveSlots", 3, 1, 100, 1,"Quicksave Slots");
    t.setDescription("Number of additional quicksaves");
    t.Data.NewCampaign <- true;

    //BOOL
    local t = saveslotPage.addBooleanSetting("useBronzemanSettings", false, "Use Bronzeman settings for autosaves");
    t.setDescription("Overrides the standart autosave settings and instead makes autosaves specified by the Bronzeman settings. Show options excluded.");
    t.Data.NewCampaign <- true;
}