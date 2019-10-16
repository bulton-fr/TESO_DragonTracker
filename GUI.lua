DragonTracker.GUI = {}

-- @var table The TopLevelControl in interface
DragonTracker.GUI.container = nil

-- @var table List of GUIItems associate to a dragon
DragonTracker.GUI.items     = {}

-- @var number Number of GUIItems in items
DragonTracker.GUI.nbItems   = 0

--[[
-- Initialise the GUI
--]]
function DragonTracker.GUI:init()
    self:obtainContainer()
    self:defineFragment()
    self:restorePosition()
end

--[[
-- Obtain the TopLevelControl's table
--]]
function DragonTracker.GUI:obtainContainer()
    self.container = DragonTrackerGUI
end

--[[
-- Restore the GUI's position from savedVariables
--]]
function DragonTracker.GUI:restorePosition()
    local left = DragonTracker.savedVariables.left
    local top  = DragonTracker.savedVariables.top

    self.container:ClearAnchors()
    self.container:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

--[[
-- Save the GUI's position from savedVariables
--]]
function DragonTracker.GUI:savePosition()
    DragonTracker.savedVariables.left = self.container:GetLeft()
    DragonTracker.savedVariables.top  = self.container:GetTop()
end

--[[
-- Define GUI has a fragment linked to scenes.
-- With that, the GUI is hidden when we open a menu (like inventory or map)
--]]
function DragonTracker.GUI:defineFragment()
    local fragment = ZO_SimpleSceneFragment:New(self.container)

    SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)
    SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
end

--[[
-- Hide or show all GUIItems.
--
-- @param boolean status true to show it, false to hide it
--]]
function DragonTracker.GUI:display(status)
    -- self.container:SetHidden(not status) -- Not work :(
    
    local itemIdx = 1
    for itemIdx = 1, self.nbItems do
        self.items[itemIdx]:display(status)
    end
end

--[[
-- To create a GUIItem instance for a Dragon and show it
--
-- @param Dragon dragon The dragon instance to link with the new GUIItem
--
-- @return GUIItem
--]]
function DragonTracker.GUI:createItem(dragon)
    local item    = DragonTracker.GUIItem:new(dragon)
    local itemIdx = self.nbItems + 1

    self.items[itemIdx] = item
    self.nbItems        = itemIdx

    item:show()

    -- To have the correct valuectr x coord when loading
    self:changeLabelType(DragonTracker.savedVariables.labelFormat)

    return item
end

--[[
-- To reset the list of GUIItems
--]]
function DragonTracker.GUI:resetItem()
    local itemIdx = 1

    for itemIdx = 1, self.nbItems do
        self.items[itemIdx]:clear()
        self.items[itemIdx]:hide()
    end

    self.items   = {}
    self.nbItems = 0
end

--[[
-- Define the label type to use on  the location name.
--]]
function DragonTracker.GUI:labelUseName()
    self:changeLabelType("ln")
end

--[[
-- Define the label type to use on  the cardinal point.
--]]
function DragonTracker.GUI:labelUseCardinalPoint()
    self:changeLabelType("cp")
end

--[[
-- Change the label to use and call the method to move the value controler
-- relative to the max width of labels.
--
-- @param string newType The new type of label ("cp" or "ln")
--]]
function DragonTracker.GUI:changeLabelType(newType)
    DragonTracker.savedVariables.labelFormat = newType

    local itemIdx   = 1
    local widthMax  = 0
    local widthText = 0

    for itemIdx = 1, self.nbItems do
        widthText = self.items[itemIdx]:changeTitleType(newType)

        if widthText > widthMax then
            widthMax = widthText
        end
    end

    for itemIdx = 1, self.nbItems do
        self.items[itemIdx]:moveValueCtr(widthMax)
    end
end
