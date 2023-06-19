::Brass <- {
    ID = "mod_bronzeman_and_adjustable_saveslots",
    Version = "1.1.0",
    Name = "Bronzeman & adjustable Saveslots"
};
::Const.BrassMod <- {};


::mods_registerMod(::Brass.ID, ::Brass.Version, ::Brass.Name);
::mods_queue(::Brass.ID, "mod_msu", function()
{
    ::Brass.Mod <- ::MSU.Class.Mod( ::Brass.ID, ::Brass.Version, ::Brass.Name);
    ::Brass.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/OberKnirps/Bronzeman-and-adjustable-saveslots");
    ::Brass.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);
    ::Brass.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/632");

    ::Const.BrassMod.addSettings();
    ::Const.BrassMod.saveslotOverride();
})