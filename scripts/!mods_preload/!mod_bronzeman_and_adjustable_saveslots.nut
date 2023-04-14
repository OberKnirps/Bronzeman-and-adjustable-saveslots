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
    ::Const.BrassMod.addSettings();
    ::Const.BrassMod.saveslotOverride();
})