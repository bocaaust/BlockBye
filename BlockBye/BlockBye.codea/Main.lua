-- BlockBye
--Copyright Austin Lubetkin 2015
--All Rights Reserved
displayMode(FULLSCREEN_NO_BUTTONS)
-- Use this function to perform your initial setup
function setup()
    math.randomseed(os.date("*t")["month"]*os.date("*t")["day"]*os.date("*t")["hour"]*os.date("*t")["min"]*os.date("*t")["sec"]*os.date("*t")["wday"])
    tween.stopAll()
    font("Cyberverse")
    orientation = CurrentOrientation
    step = ElapsedTime
    timer = ElapsedTime
    blocks = {}
    difficulty = {5,20,60}
    level = 0
    --parameter.integer(level,1,3,1)
    starting = true
    rectMode(CORNER)
    points = 0
    index = {4./10.,5,1./10.}
    openings = {}
    for w = 1,2 do
        openings[w] = {}
        temp = math.random(1,10)
        for i = 1,10 do
            openings[w][i] = 1
        end
        openings[w][temp] = 0
    end
    hitting = false
    flying = {}
    flyingindex = 1
    blocks = {}
    -- if playing == nil then
    -- playing = false
    music("Dropbox:My Song 9",true,0.1)
    -- end
    m = mesh()
    -- m.vertices = {vec2(0,HEIGHT/4),vec2(WIDTH,HEIGHT/4),vec2(WIDTH/2,0)}
    ridx = m:addRect(0,0,0,0)
    m.texture = "Project:bar2"
    m.shader = shader("Effects:Ripple")
    continuos = {3./40.}
    flowing = tween(3.-.2*level,continuos,{0.},tween.easing.linear)
end

function flow()
    continuos = {3./40.}
    flowing = tween(3.-.2*level,continuos,{0.},tween.easing.linear)
end

-- This function gets called once every frame
function draw()
    physics.gravity(vec3(0,-1,0))
    m:setRect(ridx,WIDTH/2,HEIGHT/16*3.2,WIDTH,HEIGHT/4)
    m.shader.time = ElapsedTime
    m.shader.freq = 1
    if starting then
        background(255, 255, 255, 255)
        fill(0, 255, 251, 255)
        fontSize(WIDTH/9.5)
        text("Tap To Start",WIDTH/2,HEIGHT/4*3)
        fontSize(WIDTH/19)
        text("HIGHSCORE:   "..tostring(math.tointeger(readLocalData("hs",0))),WIDTH/2,HEIGHT/2)
        if CurrentTouch.state == BEGAN then
            starting = false
        end
    else
        if changing then
        fill(255, 255, 255, 255)
        rect(0,0,WIDTH,HEIGHT)
        end
        fill(235, 235, 235, 169)
        rect(0,0,WIDTH,HEIGHT)
        fontSize(WIDTH/4)
        for i = 4,10 do
        if points >= 1000*(10^(i-4)) then
            level = i-4
            fontSize(WIDTH/i)
        end
        end
        fill(0, 84, 125+(10-index[2])*25, 25*index[2])
        text(points,WIDTH/1.98,HEIGHT/9*4)
        fill(0, 0, 0, 119)
        text(points,WIDTH/2,HEIGHT/9*4)
        m:draw()
        strokeWidth(5.0)
        for y = 1,55 do
            stroke(133, 223-y, 202, 255-y*5)
            line(0,HEIGHT/4-(HEIGHT/220*y),WIDTH,HEIGHT/4-(HEIGHT/220*y))
        end
        stroke(235, 235, 235, 62)
        strokeWidth(2)
        
        for i = 1,#openings do
            zero = false
            zero2 = false
            for t = 1,10 do
                fill(80+t*4.5, 217, 205+(5*i), 235)
                if openings[i][t] == 1 then
                    rect(WIDTH/10*(t-1),HEIGHT-(i-1)*HEIGHT*3/40+HEIGHT*continuos[1],WIDTH/10,HEIGHT*3/40)
                else
                    if zero then
                        zero2 = true
                    end
                    zero = true
                end
            end
        end
        strokeWidth(0)
        if ElapsedTime-timer >= 3.-.2*level then
            timer = ElapsedTime
            addrow()
            flow()
        end
        if ElapsedTime-step >= .5 then
            changing = false
            step = ElapsedTime
            if index[2] >= 10 or index[2] <= 1 then
                sound(SOUND_HIT, 38053)
                index[3] = index[3] * (-1)
            end
            if index[3] > 0 then
                index[2] = index[2]+1
            else
                index[2] = index[2]-1
            end
            tween((1./(2.)),index,{index[1]+index[3],index[2],index[3]})
        end
        fill(101,217,255,255)
        rect(index[1]*WIDTH,0,WIDTH/10,HEIGHT*3/40)
        if CurrentTouch.state == BEGAN and hitting then
            hitting = false
            sound(SOUND_HIT, 14779)
            hitbox(index[2])
        end
        if CurrentTouch.state == ENDED then
            hitting = true
        end
        if openings[12] ~= nil then
            for r = 1,10 do
                if openings[12][r] == 1 then
                    sound(SOUND_PICKUP, 13222)
                    if points > readLocalData("hs",0) then
                        saveLocalData("hs",points)
                    if gamecenter.enabled() then
                        gamecenter.submitScore(points)
                    end
                    end
                    setup()
                    break
                end
            end
        end
        fill(0, 143, 255, 136)
        if flyingindex > 0 then
            for d = 1,#flying do
                if flying[d].y < flying[d].z then
                    rect(flying[d].x*WIDTH/10,flying[d].y,WIDTH/10,HEIGHT*3/40)
                    flying[d].y = flying[d].y + HEIGHT/40
                end
            end
        end
        fontSize(WIDTH/4)
        for i = 4,10 do
        if points >= 1000*(10^(i-4)) then
        fontSize(WIDTH/i)
        end
        end
        fill(0, 23, 125+(10-index[2])*25, 5*index[2])
        text(points,WIDTH/1.98,HEIGHT/9*4)
        fill(30, 32, 70, 100)
        text(points,WIDTH/2,HEIGHT/9*4)
        
    end
    for i, block in pairs(blocks) do
        drawblocks(block)
    end
end

function drawblocks(block)
    pushStyle()
    pushMatrix()
    rectMode(CORNER)
    translate(block.x, block.y)
    rotate(block.angle)
    if block.info > 0 then
        block.info = block.info - 8
    elseif blocks[i] ~= nil then
    blocks[i]:destroy()
    table.remove(blocks,i)
    end
    fill(0, 143, 197, block.info)
    rect(block.points[1].x,block.points[1].y+HEIGHT/40*3,WIDTH/10,HEIGHT*3/40)
    popMatrix()
    popStyle()
end
function addblock(i)
    for t = 1,10 do
        math.randomseed(t)
        body = physics.body(POLYGON,vec2(0,0),vec2(WIDTH/10,0),vec2(WIDTH/10,HEIGHT*3/40),vec2(0,HEIGHT*3/40))
        body.info = 255
        body.interpolate = true
        body.x = WIDTH/10*(t-1)
        body.y = HEIGHT-i*HEIGHT*3/40
        body:applyForce(vec2(math.random(-5000,5000),0))
        table.insert(blocks,body)
    end
end
function addrow()
    temp = #openings
    openings[#openings+1] = {}
    for q = 0, temp-1 do
        openings[#openings-q] = openings[temp-q]
    end
    openings[1] = {1,1,1,1,1,1,1,1,1,1}
    openings[1][math.random(1,10)] = 0
end

function hitbox(int)
    if int ~= nil then
        points = points + 100
        hashit = true
        if openings[#openings+1] == nil then openings[#openings+1] = {0,0,0,0,0,0,0,0,0,0} end
        tempint = #openings
        while hashit do
            if tempint == 0 then
                hashit = false
                break
            end
            if openings[tempint][int] == 0 then
                tempint = tempint - 1
            else
                hashit = false
            end
        end
        
        openings[tempint+1][int] = 1
        check = true
        for u = 1,10 do
            if openings[tempint+1][u] == 0 then
                check = false
            end
        end
        if check then
            -- for f = 1,10 do
            addblock(tempint+1)
            --end
            points = points+1000
            sound(SOUND_POWERUP, 14775)
            temp = #openings+1
            --q = tempint
            for q = tempint+1, temp do
                openings[q] = openings[q+1]
                --  if openings[q] == {1,1,1,1,1,1,1,1,1,1} then openings[q] = nil end
            end
            openings[temp] = nil
        end
        max = #openings
        for y = 1,max do
            if openings[y] == nil or openings[y] == {1,1,1,1,1,1,1,1,1,1} then openings[y] = {0,0,0,0,0,0,0,0,0,0} end
        end
    end
    flying[flyingindex] = vec3(int-1,0,HEIGHT- (tempint-1)*HEIGHT/10)
    flyingindex = flyingindex + 1
end

function orientationChanged(orientation)
    changing = true
    end

