local menuBar = hs.menubar.new()
local isMouseDragging = false
local isMouseMoveToScroll = false

local lastWheelMovedTime = 0

local lastMiddleClickTime = 0
local sequentialClicks = ''
local sequentialClickStartFlag = true

local leftMouseUpCancelFlag = false
local rightMouseUpCancelFlag = false

function updateMenuBar()
  local mouseMoveToDragStr = ''
  local mouseMoveToScrollStr = ''

  if isMouseDragging then mouseMoveToDragStr = '+Drg' end
  if isMouseMoveToScroll then mouseMoveToScrollStr = '+Scr' end

  menuBar:setTitle('HS' .. mouseMoveToDragStr .. mouseMoveToScrollStr)
end

function keyPressFunction(key, mods, callback)
  mods = mods or {}
  callback = callback or function() end
  return function()
    hs.eventtap.event.newKeyEvent(mods, string.lower(key), true):post()
    hs.eventtap.event.newKeyEvent(mods, string.lower(key), false):post()
    callback()
  end
end

function showDraggingState(ev)
  -- For drag function of Kensinton TrackballWorks
  eventType = ev:getType()
  if eventType == hs.eventtap.event.types['leftMouseDragged'] and not isMouseDragging then
    isMouseDragging = true
    updateMenuBar()
  elseif eventType == hs.eventtap.event.types['mouseMoved'] and isMouseDragging then
    isMouseDragging = false
    updateMenuBar()
  end
  return true, { ev }
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
  local scrollSqrd = -0.005
  local scrollDeltaX = math.floor(dx * scrollMult + dx * math.abs(dx) * scrollSqrd)
  local scrollDeltaY = math.floor(dy * scrollMult + dy * math.abs(dy) * scrollSqrd)
  local scrollEvent = hs.eventtap.event.newScrollEvent({ scrollDeltaX, scrollDeltaY }, {}, 'pixel')
  scrollEvent:post()

  -- put the mouse back
  hs.mouse.setAbsolutePosition(oldMousePos)

  showDraggingState(ev)

  return true, { scrollEvent }
end

function translateScrollWheel(ev)
  local msecAfterLastWheelMoved = 0
  local msecTranslateInterval = 300

  if isMouseMoveToScroll then
    return true, {}
  end

  msecAfterLastWheelMoved = (hs.timer.absoluteTime() - lastWheelMovedTime) / 1000000
  lastWheelMovedTime = hs.timer.absoluteTime()

  if msecAfterLastWheelMoved > msecTranslateInterval then
    if ev:getProperty(hs.eventtap.event.properties['scrollWheelEventDeltaAxis1']) > 0 then
      keyPressFunction('up', {'ctrl'})()
    else
      keyPressFunction('down', {'ctrl'})()
    end
  end

  return true, {}
end

function handleSequentialClicks(ev)
  local eventType = ev:getType()
  local buttonNumber = ev:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
  local msecSequentialInterval = 300
  local msecAfterLastMiddleClick = 0

  if eventType == hs.eventtap.event.types['mouseMoved'] then
    if isMouseMoveToScroll and sequentialClickStartFlag then
      sequentialClickStartFlag = false
    end
    return false, {}
  end

  if eventType == hs.eventtap.event.types['leftMouseUp'] then
    if leftMouseUpCancelFlag then
      leftMouseUpCancelFlag = false
      return true, {}
    end
    return false, {}
  end

  if eventType == hs.eventtap.event.types['rightMouseUp'] then
    if rightMouseUpCancelFlag then
      rightMouseUpCancelFlag = false
      return true, {}
    end
    return false, {}
  end

  if eventType == hs.eventtap.event.types['middleMouseUp'] then
    if buttonNumber == 2 then
      lastMiddleClickTime = hs.timer.absoluteTime()
    end
    return false, {}
  end

  msecAfterLastMiddleClick = (hs.timer.absoluteTime() - lastMiddleClickTime) / 1000000
  if msecAfterLastMiddleClick > msecSequentialInterval then
    if sequentialClickStartFlag then
      sequentialClicks = 'M'
    else
      sequentialClickStartFlag = true
      sequentialClicks = ''
    end
    return false, {}
  end

  if buttonNumber == 0 then
    sequentialClicks = sequentialClicks .. 'L'
  elseif buttonNumber == 1 then
    sequentialClicks = sequentialClicks .. 'R'
  elseif buttonNumber == 2 then
    sequentialClicks = sequentialClicks .. 'M'
  end

  -- print ('Sequential Click: ' .. sequentialClicks)

  if sequentialClicks == 'ML' then
    keyPressFunction('f4')() -- Launchpad
    leftMouseUpCancelFlag = true
  elseif sequentialClicks == 'MML' then
    keyPressFunction('f11')() -- Show Desktop
    leftMouseUpCancelFlag = true
  else
    return false, {} -- Not assigned, pass through
  end

  isMouseMoveToScroll = false
  updateMenuBar()
  return true, {}
end

updateMenuBar()

eventShowDraggingState = hs.eventtap.new({
  hs.eventtap.event.types['mouseMoved'],
  hs.eventtap.event.types['leftMouseDragged'],
}, showDraggingState)
eventShowDraggingState:start()

eventToggleMouseMoveToScroll = hs.eventtap.new({
  hs.eventtap.event.types['middleMouseDown'],
}, toggleMouseMoveToScroll)
eventToggleMouseMoveToScroll:start()

eventTranslateMouseMoveToScroll = hs.eventtap.new({
  hs.eventtap.event.types['mouseMoved'],
  hs.eventtap.event.types['middleMouseDragged'],
}, translateMouseMoveToScroll)
eventTranslateMouseMoveToScroll:start()

eventTranslateScrollWheel = hs.eventtap.new({
  hs.eventtap.event.types['scrollWheel'],
}, translateScrollWheel)
eventTranslateScrollWheel:start()

eventHandleSequentialClicks = hs.eventtap.new({
  hs.eventtap.event.types['mouseMoved'],
  hs.eventtap.event.types['leftMouseUp'],
  hs.eventtap.event.types['leftMouseDown'],
  hs.eventtap.event.types['rightMouseUp'],
  hs.eventtap.event.types['rightMouseDown'],
  hs.eventtap.event.types['middleMouseUp'],
  hs.eventtap.event.types['middleMouseDown'],
}, handleSequentialClicks)
eventHandleSequentialClicks:start()
