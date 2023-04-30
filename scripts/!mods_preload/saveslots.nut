::Const.BrassMod.saveslotOverride <- function() {
    ::mods_hookNewObject("states/world_state",function(o){
        local settings = Brass.Mod.ModSettings;
        //modify saving
        local saveCampaign = o.saveCampaign;
        o.saveCampaign = function(_campaignFileName, _campaignLabel = null){
            local saveToSaveslot = function(_campaignFileName, _campaignLabel, _flagName, _settingsName){
                //increment saveslot
                this.m.Flags.set(_flagName,
                    this.m.Flags.get(_flagName) % settings.getSetting(_settingsName).getValue() + 1);
                //save in new saveslot
                if(_campaignLabel == null){
                    return saveCampaign(_campaignFileName + "_" + this.m.Flags.get(_flagName), _campaignFileName);
                }else{
                    return saveCampaign(_campaignFileName + "_" + this.m.Flags.get(_flagName), _campaignLabel);
                }
            };

            //initialize flags
            if(!this.m.Flags.has("lastIronmanSlot")){
                this.m.Flags.set("lastIronmanSlot", 0)
            }
            if(!this.m.Flags.has("lastAutosaveSlot")){
                this.m.Flags.set("lastAutosaveSlot", 0)
            }
            if(!this.m.Flags.has("lastQuicksaveSlot")){
                this.m.Flags.set("lastQuicksaveSlot", 0)
            }

            if(this.World.Assets.isIronman()){
                //bronzeman saves
                if(!this.m.Flags.has("bronzemanSave")){
                    this.m.Flags.set("bronzemanSave", "")
                }
                switch(this.World.Flags.get("bronzemanSave")){
                    case "settlementSave":
                        if(settings.getSetting("saveLeaveSettlement").getValue()){
                            saveCampaign(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_leftSettlement", this.World.Assets.getName() + " Left Settlement");
                        }
                        break;
                    case "beforeCombatSave":
                        if(settings.getSetting("saveBeforeCombat").getValue()){
                            saveCampaign(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_beforeCombat", this.World.Assets.getName() + " Before Combat");
                        }
                        break;
                    case "afterCombatSave":
                        if(settings.getSetting("saveAfterCombat").getValue()){
                            saveCampaign(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_afterCombat", this.World.Assets.getName() + " After Combat");
                        }
                        break;
                }

                //clear all bornzeman save flags
                this.m.Flags.set("bronzemanSave", "");

                //ironman saves
                if(settings.getSetting("enableIronmanSlots").getValue()){
                    //additional ironman slots
                    return saveToSaveslot(_campaignFileName, _campaignLabel,"lastIronmanSlot","ironmanSlots");
                }else{
                    //regular ironman
                    return saveCampaign(_campaignFileName, _campaignLabel);
                }
            }else{
                if(_campaignFileName == "autosave"){
                    //autosave
                    return saveToSaveslot(_campaignFileName, _campaignLabel,"lastAutosaveSlot","autosaveSlots");
                }
                if(_campaignFileName == "quicksave"){
                    //quicksave
                    return saveToSaveslot(_campaignFileName, _campaignLabel,"lastQuicksaveSlot","quicksaveSlots");
                }
            }
        };

        //modify loading
        local loadCampaign = o.loadCampaign;
        o.loadCampaign = function( _campaignFileName ){
            if (_campaignFileName == "quicksave" && this.m.Flags.has("lastQuicksaveSlot")){
                _campaignFileName =  "quicksave" + "_" + this.m.Flags.get("lastQuicksaveSlot");
            }
            loadCampaign(_campaignFileName);
        };

        local canLoad = this.World.canLoad
        this.World.canLoad <- function(_campaignFileName){
            if (_campaignFileName == "quicksave" && this.World.State.m.Flags.has("lastQuicksaveSlot")){
                _campaignFileName =  "quicksave" + "_" + this.World.State.m.Flags.get("lastQuicksaveSlot");
            }
            return canLoad(_campaignFileName);
        };

        //add flag for bronzeman before-combat saves
        local startScriptedCombat = o.startScriptedCombat;
        o.startScriptedCombat = function( _properties , _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking){
            this.World.Flags.set("bronzemanSave", "beforeCombatSave");
            return startScriptedCombat( _properties , _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking);
        }
        local startCombat = o.startCombat;
        o.startCombat = function( _pos ){
            this.World.Flags.set("bronzemanSave", "beforeCombatSave");
            return startCombat( _pos );
        }

        //add flag for bronzeman after-combat saves
        local onCombatFinished = o.onCombatFinished;
        o.onCombatFinished = function(){
            this.World.Flags.set("bronzemanSave", "afterCombatSave");
            return onCombatFinished();
        }

        //add flag for bronzeman settlement saves and save before entering
        local showTownScreen = o.showTownScreen;
        o.showTownScreen = function(){
            if(settings.getSetting("saveEnterSettlement").getValue()){
                saveCampaign(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_enteredSettlement", this.World.Assets.getName() + " Entered Settlement");
            }
            this.m.Flags.set("bronzemanSave", "settlementSave");
            return showTownScreen();
        };

    });

    //modify savegame deletion on finish
    ::mods_hookNewObject("states/world/asset_manager",function(o){
        local getGameFinishData = o.getGameFinishData;
        o.getGameFinishData = function( _gameWon ){
            if (this.isIronman()) {
                local fileNamePrefix = this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID();
                //delete normal ironman save
                if(this.World.canLoad(fileNamePrefix)){
                    this.PersistenceManager.deleteStorage(fileNamePrefix);
                }
                //delete additional ironman saves
                for(local i=1;i<=100;i+=1){
                    if(this.World.canLoad(fileNamePrefix + "_" + i)){
                        this.PersistenceManager.deleteStorage(fileNamePrefix + "_" + i);
                    }else{
                        break;
                    }
                }
                //delete bronzeman saves
                if(this.World.canLoad(fileNamePrefix + "_enteredSettlement")){
                    this.PersistenceManager.deleteStorage(fileNamePrefix + "_enteredSettlement");
                }
                if(this.World.canLoad(fileNamePrefix + "_leftSettlement")){
                    this.PersistenceManager.deleteStorage(fileNamePrefix + "_leftSettlement");
                }
                if(this.World.canLoad(fileNamePrefix + "_beforeCombat")){
                    this.PersistenceManager.deleteStorage(fileNamePrefix + "_beforeCombat");
                }
                if(this.World.canLoad(fileNamePrefix + "_afterCombat")){
                    this.PersistenceManager.deleteStorage(fileNamePrefix + "_afterCombat");
                }
            }
            return getGameFinishData(_gameWon);
        };
    });

    //delete ironman and bronzeman saves in menu in the right way
    local deleteIronAndBronzemanSaves = function(_campaignFileName){
        //mass delete if collapsed ironman save is targeted otherwise delete only the specified file
        if(Brass.Mod.ModSettings.getSetting("hideAdditionalIronmanSlots").getValue()) {
            //test for ironman and find UID
            local storages = this.PersistenceManager.queryStorages();
            local UID = null;
            local isIronman = false;
            foreach (storageMeta in storages) {
                if (storageMeta.getFileName() == _campaignFileName && storageMeta.getInt("ironman") == 1) {

                    isIronman = true;
                    if (::MSU.String.startsWith(_campaignFileName, storageMeta.getName())) {
                        local end = _campaignFileName.find("_", storageMeta.getName().len() + 1);
                        if (end == null) {
                            //normal ironman save delete all with UID
                            UID = _campaignFileName;
                            break;
                        } else {
                            //backup ironman save, delete all with UID
                            UID = _campaignFileName.slice(0, end);
                            break;
                        }
                    } else {
                        //is bronze save delete only this
                        break;
                    }
                }
            }
            if (isIronman && UID) {
                //this.logDebug("BRASS: Delete all savegames starting with '" + UID + "'");
                local deleteList = [];
                foreach (storageMeta in storages) {
                    if (::MSU.String.startsWith(storageMeta.getFileName(), UID)) this.PersistenceManager.deleteStorage(storageMeta.getFileName());
                }
            }
        }
    }
    ::mods_hookNewObject("ui/screens/menu/modules/load_campaign_menu_module",function(o){
        local onDeleteButtonPressed = o.onDeleteButtonPressed;
        o.onDeleteButtonPressed = function(_campaignFileName){
            deleteIronAndBronzemanSaves(_campaignFileName);
            onDeleteButtonPressed(_campaignFileName);
        };
    });
    ::mods_hookNewObject("ui/screens/menu/modules/save_campaign_menu_module",function(o){
        local onDeleteButtonPressed = o.onDeleteButtonPressed;
        o.onDeleteButtonPressed = function(_campaignFileName){
            deleteIronAndBronzemanSaves(_campaignFileName);
            onDeleteButtonPressed(_campaignFileName);
        };
    });


    //hide ironman saves
    ::mods_hookNewObject("ui/global/data_helper",function(o){
        local convertCampaignStoragesToUIData = o.convertCampaignStoragesToUIData;
        o.convertCampaignStoragesToUIData = function (){
            local res = convertCampaignStoragesToUIData();
            local isWorldmap = ("Assets" in this.World) && this.World.Assets != null;

            //check if name ends with bronzeman suffix
            local bronzemanSuffixes = ["_enteredSettlement", "_leftSettlement", "_beforeCombat", "_afterCombat"]
            local isBronzemanSave = function(name){
                foreach(suffix in bronzemanSuffixes){
                    if(::MSU.String.endsWith(name,suffix)) return true;
                }
                return false;
            }

            //search for unique ironman saves
            local ironsaves = [[],[]];
            foreach(e in res) {
                if(!isBronzemanSave(e.fileName)) {
                    local end = e.fileName.find("_", e.name.len() + 1);
                    local name = e.fileName;
                    if (end != null) {
                        name = e.fileName.slice(0, end);
                    }
                    if (e.isIronman) {
                        if (ironsaves[0].find(name) == null) {
                            ironsaves[0].push(name);
                            ironsaves[1].push(e.creationDate);
                        }
                    }
                }
            }

            ///create filters that can be chained///
            //filterHideAdditionalSlots
            local filterHideAdditionalSlots = function(index, val){
                foreach(i,name in ironsaves[0]){
                    if(::MSU.String.startsWith(val.fileName,name)
                        && val.creationDate != ironsaves[1][i]
                        && !isBronzemanSave(val.fileName))
                        return false;
                }
                return true;
            }
            //filterIronmanHideIngame
            local filterIronmanHideIngame = function(index, val){
                if(::MSU.String.startsWith(val.fileName, this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID())
                    && !isBronzemanSave(val.fileName)) {
                    return false;
                }else{
                    return true;
                }
            }
            //filterIronmanHideMenu
            local filterIronmanHideMenu = function(index, val){
                foreach(i,name in ironsaves[0]){
                    if(::MSU.String.startsWith(val.fileName,name)
                        && !isBronzemanSave(val.fileName))
                        return false;
                }
                return true;
            }
            //filterBronzemanHideIngame
            local filterBronzemanHideIngame = function(index, val){
                if(::MSU.String.startsWith(val.fileName, this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID())
                    && isBronzemanSave(val.fileName)) {
                    return false;
                }else{
                    return true;
                }
            }
            //filterBronzemanHideMenu
            local filterBronzemanHideMenu = function(index, val){
                foreach(i,name in ironsaves[0]){
                    //this.logDebug("BRASS: Check " + name);
                    if(::MSU.String.startsWith(val.fileName,name)
                        && isBronzemanSave(val.fileName)) {
                        //this.logDebug("BRASS: Hide " + val.fileName);
                        return false;
                    }
                }
                return true;
            }
            if(Brass.Mod.ModSettings.getSetting("hideAdditionalIronmanSlots").getValue()) {
                //this.logDebug("BRASS: Hide additional saves");
                res = res.filter(filterHideAdditionalSlots);
            }

            if (isWorldmap && this.World.Assets.isIronman()) {
                if((Brass.Mod.ModSettings.getSetting("showIronmanSaves").getValue() == "Menu" || Brass.Mod.ModSettings.getSetting("showIronmanSaves").getValue() == "Disabled")){
                    //this.logDebug("BRASS: Hide Ironman Ingame");
                    res = res.filter(filterIronmanHideIngame);
                }
                if((Brass.Mod.ModSettings.getSetting("showBronzeSaves").getValue() == "Menu" || Brass.Mod.ModSettings.getSetting("showBronzeSaves").getValue() == "Disabled")){
                    //this.logDebug("BRASS: Hide Brozemanman Ingame");
                    res = res.filter(filterBronzemanHideIngame);
                }
                ironsaves[0].remove(ironsaves[0].find(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID()));
            }
            if((Brass.Mod.ModSettings.getSetting("showIronmanSaves").getValue() == "Ingame" || Brass.Mod.ModSettings.getSetting("showIronmanSaves").getValue() == "Disabled")){
                //this.logDebug("BRASS: Hide Ironman Menu");
                res = res.filter(filterIronmanHideMenu);
            }
            if((Brass.Mod.ModSettings.getSetting("showBronzeSaves").getValue() == "Ingame" || Brass.Mod.ModSettings.getSetting("showBronzeSaves").getValue() == "Disabled")){
                //this.logDebug("BRASS: Hide Brozemanman Menu");
                res = res.filter(filterBronzemanHideMenu);
            }

            return res;
        };
    });
}