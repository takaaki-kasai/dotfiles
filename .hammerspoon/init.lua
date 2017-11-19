local menuBar = hs.menubar.new()
local isMouseMoveToDrag = false
local isMouseMoveToScroll = false
local isMouseLeftCancelling = false
local isMouseRightCancelling = false
local isMouseMiddleCancelling = false
local isMouseButton4Cancelling = false

local forcePropagateLeftMouseDown = false

function doNothing()
end

function updateMenuBar()
  local mouseMoveToDragStr = ''
  local mouseMoveToScrollStr = ''

  if isMouseMoveToDrag then mouseMoveToDragStr = '+Drg' end
  if isMouseMoveToScroll then mouseMoveToScrollStr = '+Scr' end

  menuBar:setTitle('HS' .. mouseMoveToDragStr .. mouseMoveToScrollStr)
end

function toggleMouseMoveToDrag(ev)
  -- Accept button4 only
  if not (ev:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber']) == 3) then
    return false, {}
  end

  local oldMousePos = hs.mouse.getAbsolutePosition()
  if isMouseMoveToDrag then
    isMouseMoveToDrag = false
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['leftMouseUp'], oldMousePos):post()
  else
    isMouseMoveToDrag = true
    forcePropagateLeftMouseDown = true
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['leftMouseDown'], oldMousePos):post()
  end
  updateMenuBar()

  return true, {}
end

function translateMouseMoveToDrag(ev)
  if not isMouseMoveToDrag then
    return false, {}
  end
  -- print ('dx: ' .. tostring(ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])) .. ', dy: ' .. tostring(ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])))
  local oldMousePos = hs.mouse.getAbsolutePosition()
  local dx = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
  local dy = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
  local dragEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['leftMouseDragged'], { x = oldMousePos['x'] + dx, y = oldMousePos['y'] + dy })
  return false, { dragEvent }
end

function toggleMouseMoveToScroll(ev)
  -- Accept middle button only
  if not (ev:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber']) == 2) then
    return false, {}
  end

  isMouseMoveToScroll = not isMouseMoveToScroll
  updateMenuBar()

  return true, {}
end

function translateMouseMoveToScroll(ev)
  if not isMouseMoveToScroll then
    return false, {}
  end

  local oldMousePos = hs.mouse.getAbsolutePosition()
  local dx = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
  local dy = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
  local scrollMult = -1
  local scrollEvent = hs.eventtap.event.newScrollEvent({ dx * scrollMult, dy * scrollMult }, {}, 'pixel')
  scrollEvent:post()

  -- put the mouse back
  hs.mouse.setAbsolutePosition(oldMousePos)

  return true, { scrollEvent }
end

function handleSimultaniousMouseButtonPress(ev)
  local eventType = ev:getType()

  if isMouseMoveToDrag then
    if eventType == hs.eventtap.event.types['leftMouseDown'] then
      if forcePropagateLeftMouseDown then
        forcePropagateLeftMouseDown = false
        return false, {}
      else
        return true, {}
      end
    end
    if eventType == hs.eventtap.event.types['leftMouseUp'] then
      isMouseMoveToDrag = false
      updateMenuBar()
      return false, {}
    end
  end

--   if eventType == hs.eventtap.event.types['leftMouseDown'] then
--     print ('Mouse Left Down')
--     if ev:getButtonState(1) then
--       if not isMouseRightCancelling and not isMouseLeftCancelling then
--         print ('Mouse Right and Left')
--         isMouseRightCancelling = true
--         isMouseLeftCancelling = true
--         toggleMouseMoveToDrag(ev)
--       end
--       return true, {}
--     end
--     return true, {}
--   elseif eventType == hs.eventtap.event.types['leftMouseUp'] then
--     print ('Mouse Left Up')
--     if isMouseLeftCancelling then
--       isMouseLeftCancelling = false
--       return true, {}
--     else
--       -- print ('Mouse Left Click')
--       isMouseLeftCancelling = true
--       local oldMousePos = hs.mouse.getAbsolutePosition()
--       leftMouseDownEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['leftMouseDown'], oldMousePos):post()
--       leftMouseUpEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['leftMouseUp'], oldMousePos):post()
--       return true, { leftMouseDownEvent, leftMouseUpEvent }
--     end
--   elseif eventType == hs.eventtap.event.types['rightMouseDown'] then
--     -- print ('Mouse Right Down')
--     if ev:getButtonState(0) then
--       if not isMouseLeftCancelling and not isMouseRightCancelling then
--         print ('Mouse Left and Right')
--         isMouseLeftCancelling = true
--         isMouseRightCancelling = true
--         toggleMouseMoveToDrag(ev)
--       end
--       return true, {}
--     elseif ev:getButtonState(2) then
--       if not isMouseMiddleCancelling and not isMouseRightCancelling then
--         print ('Mouse Middle and Right')
--         isMouseMiddleCancelling = true
--         isMouseRightCancelling = true
--       end
--       return true, {}
--     elseif ev:getButtonState(3) then
--       if not isMouseButton4Cancelling and not isMouseRightCancelling then
--         print ('Mouse Button4 and Right')
--         isMouseButton4Cancelling = true
--         isMouseRightCancelling = true
--       end
--       return true, {}
--     end
--     return true, {}
--   elseif eventType == hs.eventtap.event.types['rightMouseUp'] then
--     -- print ('Mouse Right Up')
--     if isMouseRightCancelling then
--       isMouseRightCancelling = false
--       return true, {}
--     else
--       -- print ('Mouse Right Click')
--       isMouseRightCancelling = true
--       local oldMousePos = hs.mouse.getAbsolutePosition()
--       rightMouseDownEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['rightMouseDown'], oldMousePos):post()
--       rightMouseUpEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types['rightMouseUp'], oldMousePos):post()
--       return true, { rightMouseDownEvent, rightMouseUpEvent }
--     end
--   elseif eventType == hs.eventtap.event.types['middleMouseDown'] then
--     local mouseButtonNumber = ev:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
--     if mouseButtonNumber == 2 then
--       -- print ('Mouse Middle Down')
--       if ev:getButtonState(1) then
--         if not isMouseRightCancelling and not isMouseMiddleCancelling then
--           print ('Mouse Right and Middle')
--           isMouseRightCancelling = true
--           isMouseMiddleCancelling = true
--         end
--         return true, {}
--       end
--       if ev:getButtonState(3) then
--         if not isMouseButton4Cancelling and not isMouseMiddleCancelling then
--           print ('Mouse Button4 and Middle')
--           isMouseButton4Cancelling = true
--           isMouseMiddleCancelling = true
--         end
--         return true, {}
--       end
--     elseif mouseButtonNumber == 3 then
--       -- print ('Mouse Buuton4 Down')
--       if ev:getButtonState(1) then
--         if not isMouseRightCancelling and not isMouseButton4Cancelling then
--           print ('Mouse Right and Button4')
--           isMouseRightCancelling = true
--           isMouseButton4Cancelling = true
--         end
--         return true, {}
--       end
--       if ev:getButtonState(2) then
--         if not isMouseMiddleCancelling and not isMouseButton4Cancelling then
--           print ('Mouse Middle and Button4')
--           isMouseMiddleCancelling = true
--           isMouseButton4Cancelling = true
--         end
--         return true, {}
--       end
--     end
--   elseif eventType == hs.eventtap.event.types['middleMouseUp'] then
--     local mouseButtonNumber = ev:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
--     if mouseButtonNumber == 2 then
--       -- print ('mouse Middle Up')
--       if isMouseMiddleCancelling then
--         isMouseMiddleCancelling = false
--         return true, {}
--       end
--     elseif mouseButtonNumber == 3 then
--       -- print ('mouse Buuton4 Up')
--       if isMouseButton4Cancelling then
--         isMouseButton4Cancelling = false
--         return true, {}
--       end
--     end
--   end
end

-- function translateScrollWheel(ev)
--   if isMouseMoveToScroll then
--     return false, {}
--   end
--   print ('translateScrollWheel')
--   print (ev:getProperty(hs.eventtap.event.properties['scrollWheelEventDeltaAxis1']))
--   return true, {}
-- end

updateMenuBar()

-- evetTest = hs.eventtap.new({
--   hs.eventtap.event.types['leftMouseDragged']
-- }, function(ev)
--   local oldMousePos = hs.mouse.getAbsolutePosition()
--   local dx = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
--   local dy = ev:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
--   print ('x: ' .. tostring(oldMousePos['x']) .. ', y: ' .. tostring(oldMousePos['y']))
--   print ('dx: ' .. tostring(dx) .. ', dy: ' .. tostring(dy))
--   print ('x + dx: ' .. tostring(oldMousePos['x'] + dx) .. ', y + dy: ' .. tostring(oldMousePos['y'] + dy))
-- end)
-- evetTest:start()

eventToggleMouseMoveToDrag = hs.eventtap.new({
  hs.eventtap.event.types['middleMouseDown']
}, toggleMouseMoveToDrag)
eventToggleMouseMoveToDrag:start()

eventTranslateMouseMoveToDrag = hs.eventtap.new({
  hs.eventtap.event.types['mouseMoved'],
}, translateMouseMoveToDrag)
eventTranslateMouseMoveToDrag:start()

eventToggleMouseMoveToScroll = hs.eventtap.new({
  hs.eventtap.event.types['middleMouseDown']
}, toggleMouseMoveToScroll)
eventToggleMouseMoveToScroll:start()

eventTranslateMouseMoveToScroll = hs.eventtap.new({
  hs.eventtap.event.types['mouseMoved'],
  hs.eventtap.event.types['middleMouseDragged']
}, translateMouseMoveToScroll)
eventTranslateMouseMoveToScroll:start()

eventSimultaniousMouseButtonPress = hs.eventtap.new({
  hs.eventtap.event.types['leftMouseDown'],
  hs.eventtap.event.types['leftMouseUp'],
  hs.eventtap.event.types['rightMouseDown'],
  hs.eventtap.event.types['rightMouseUp'],
  hs.eventtap.event.types['middleMouseDown'],
  hs.eventtap.event.types['middleMouseUp']
}, handleSimultaniousMouseButtonPress)
eventSimultaniousMouseButtonPress:start()

-- eventTranslateScrollWheel = hs.eventtap.new({
--   hs.eventtap.event.types['scrollWheel']
-- }, translateScrollWheel)
-- eventTranslateScrollWheel:start()
