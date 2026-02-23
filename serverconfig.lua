Config = {}

Config.Debug = true

Config.Permissions = {
    ["steam:xxxxxxxxxxxxxxxxxxx"] = true, -- ludwig
}

Config.FilesToEdit = {
    ["Housing Config"] = { script = "bcc-housing", path = "houseconfig.lua", absolutePath = "/fxserver/txData/VORPCore_A149B8.base/resources/[EXTRAS]/[BCC]/bcc-housing/houseconfig.lua" } --pfad aus sicht der ressource, also wie im fxmanifest
}

-- Falls ich nochmal anfange: 
-- one resource can safe files into another Resource by add_filesystem_permission resource1 resource2
