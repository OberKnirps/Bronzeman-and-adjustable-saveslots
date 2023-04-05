::Const.BrassMod.saveslotOverride <- function() {
    ::mods_hookNewObject("states/world_state",function(o){
        local saveCampaign = o.saveCampaign;
        o.saveCampaign = function(_campaignFileName, _campaignLabel = null){
            local settings = Brass.Mod.ModSettings;

            local saveToSaveslot = function(_campaignFileName, _campaignLabel, _flagName, _settingsName){
                //increment saveslot
                this.m.Flags.set(_flagName,
                    this.m.Flags.get(_flagName) % settings.getSetting(_settingsName).getValue() + 1);
                //save in new saveslot
                if(_campaignLabel == null){
                    return saveCampaign(_campaignFileName + "_" + this.m.Flags.get(_flagName));
                }else{
                    return saveCampaign(_campaignFileName + "_" + this.m.Flags.get(_flagName), _campaignLabel + "_" + this.m.Flags.get(_flagName));
                }
            };

            //initialize flags
            if(!this.m.Flags.has("lastBronzemanSlot")){
                this.m.Flags.set("lastBronzemanSlot", 0)
            }
            if(!this.m.Flags.has("lastAutosaveSlot")){
                this.m.Flags.set("lastAutosaveSlot", 0)
            }
            if(!this.m.Flags.has("lastQuicksaveSlot")){
                this.m.Flags.set("lastQuicksaveSlot", 0)
            }

            if(this.World.Assets.isIronman()){
                if(settings.getSetting("bronzeman").getValue() == "enabled"){
                    //bronzeman
                    return saveToSaveslot(_campaignFileName, _campaignLabel,"lastBronzemanSlot","bronzemanSlots");
                }else{
                    //ironman
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


    ::mods_hookNewObject("states/world/asset_manager",function(o){
        local getGameFinishData = o.getGameFinishData;
        o.getGameFinishData = function( _gameWon ){
            if (this.isIronman()) {
                //delete all bronzeman saves
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
}