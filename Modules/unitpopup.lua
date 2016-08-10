local QuickLink = LibStub("AceAddon-3.0"):GetAddon("QuickLink")
local QuickLink_UNIT_POPUP = QuickLink:NewModule("QuickLink_UNIT_POPUP", "AceConsole-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuickLink", true)

------------------------------------------------------------------------
-- Target/Player Frame context menu
------------------------------------------------------------------------
function QuickLink_UNIT_POPUP:updateContextMenu()
	UnitPopupButtons["QUICKLINK"] = {text = L["QUICKLINK"], dist = 0, nested = 1 };
	UnitPopupMenus["QUICKLINK"] = {}
	for i=1,#QuickLinkPages do
		UnitPopupButtons["QUICKLINK_PAGE"..i] = {text = QuickLinkPages[i].name, dist = 0};
		table.insert(UnitPopupMenus["QUICKLINK"], "QUICKLINK_PAGE"..i);
	end
end

function addContextMenu()
	table.insert(UnitPopupMenus["SELF"], #(UnitPopupMenus["SELF"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"])-1, "QUICKLINK");
	table.insert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"])-1, "QUICKLINK");
end

function QuickLink_UNIT_POPUP:UnitPopup_OnClick(self)
	local menu = UIDROPDOWNMENU_INIT_MENU
	local index, matches = string.gsub(self.value, "QUICKLINK_PAGE", "")
	local name = nil
	local server = nil
	if matches == 1 then
		if menu['bnetIDAccount'] then  -- a bit hackish detection if we are in the BNet friendlist
			local _, _, _, _, _, bnetIDGameAccount, client, _, _, _, _, _, _, _, _, _, _, _ = BNGetFriendInfoByID(menu['bnetIDAccount'])
			if client == BNET_CLIENT_WOW then
				local _, characterName, _, realmName, realmID, _, _, _, _, _, _, _, _, _, _, _, _, _, _  = BNGetGameAccountInfo(bnetIDGameAccount)
				name, server = characterName, realmName
			end
		else
			name, server = menu['name'], menu['server']
		end
		if name then
			if not server then server = GetRealmName() end
			QuickLink:ShowUrlFrame(QuickLinkPages[tonumber(index)].name, QuickLinkPages[tonumber(index)].url, name, server);
		end
	end
end

function QuickLink_UNIT_POPUP:OnEnable()
	QuickLink_UNIT_POPUP:updateContextMenu()
	addContextMenu()
	QuickLink_UNIT_POPUP:SecureHook("UnitPopup_OnClick");
end