::Const.BrassMod.saveslotOverride <- function() {
    ::mods_hookNewObject("states/world_state",function(o){
        //modify saving
        local saveCampaign = o.saveCampaign;
        o.saveCampaign = function(_campaignFileName, _campaignLabel = null){
            local settings = Brass.Mod.ModSettings;

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
        }
    });

    //modify savegame deletion on finish
    ::mods_hookNewObject("states/world/asset_manager",function(o){
        local getGameFinishData = o.getGameFinishData;
        o.getGameFinishData = function( _gameWon ){
            if (this.isIronman()) {
                //delete all ironman saves
                if(this.World.canLoad(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID())){
                    this.PersistenceManager.deleteStorage(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID());
                }
                for(local i=1;i<=100;i+=1){
                    if(this.World.canLoad(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_" + i)){
                        this.PersistenceManager.deleteStorage(this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID() + "_" + i);
                    }else{
                        break;
                    }
                }
            }
            return getGameFinishData(_gameWon);
        };
    });

    //delete ironman and bronzeman saves in the right way
    local deleteIronAndBronzemanSaves = function(_campaignFileName){
        //test for ironman and find UID
        local storages = this.PersistenceManager.queryStorages();
        local UID = null;
        local isIronman = false;
        local deleteAll = false;
        foreach( storageMeta in storages ){
            if(storageMeta.getFileName() == _campaignFileName && storageMeta.getInt("ironman") == 1){

                isIronman = true;
                if(::MSU.String.startsWith(_campaignFileName,storageMeta.getName())){
                    deleteAll = true;
                    local end = _campaignFileName.find("_",storageMeta.getName().len()+1);
                    if(end == null){
                        //normal ironman save delete all with UID
                        UID = _campaignFileName;
                        break;
                    }else{
                        //backup ironman save, delete all with UID
                        UID = _campaignFileName.slice(0,end);
                        break;
                    }
                }else{
                    //is bronze save delete only this
                    break;
                }
            }
        }
        if(isIronman && !deleteAll){
            this.logDebug("BRASS: Delete bronzeman slot named '" + _campaignFileName +"'");
            this.PersistenceManager.deleteStorage(_campaignFileName);
        }
        if(isIronman && deleteAll){ //TODO: only if savegame hiding is on
            this.logDebug("BRASS: Delete all savegames starting with '" + UID +"'");
            local deleteList = [];
            foreach( storageMeta in storages ){
                if(::MSU.String.startsWith(storageMeta.getFileName(),UID)) this.PersistenceManager.deleteStorage(storageMeta.getFileName());
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

            /*if(Brass.Mod.ModSettings.getSetting("bronzemanHide").getValue() == "disabled") {
                return res;
            }*/
            if (isWorldmap && this.World.Assets.isIronman()) {
                //while in ironman campain, hide the savegames associated with the current world
                foreach(i, e in res) {
                    return res.filter(
                    function(index, val) {
                        return !::MSU.String.startsWith(val.fileName, this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID());
                    });
                }
            }else{
                //search for unique ironman saves
                local ironsaves = [[],[]];
                foreach(e in res){
                    local nameEnd = e.fileName.find("_", e.fileName.len()-5);
                    if(e.isIronman && nameEnd != null){
                        local name =e.fileName.slice(0,nameEnd);
                        if(ironsaves[0].find(name) == null) {
                            ironsaves[0].push(name);
                            ironsaves[1].push(e.creationDate);
                        }
                    }
                }
                //filter out all ironman saves with same ID that arent the newest
                local f = function(index, val){
                    foreach(i,name in ironsaves[0]){
                        if(::MSU.String.startsWith(val.fileName,name) && val.creationDate != ironsaves[1][i]) return false;
                    }
                    return true;
                }
                return res.filter(f);
            }
        };
    });
}