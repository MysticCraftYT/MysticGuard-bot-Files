local function exec(message, args)
    args = string.gsub(args, "`", ""):trim()
    msg = message
    local printresult = ""
    local oldPrint = print
    print = function(...)
        local arg = {...}
        for _,v in ipairs(arg) do
            printresult = printresult..tostring(v).."\t"
        end
        printresult = printresult.."\n"
    end
    local a = loadstring(args)
    if a then
        setfenv(a,getfenv())
        local _,ret = pcall(a)
        if ret==nil then
            ret = printresult
        else
            ret = tostring(ret).."\n"..printresult
        end
        local result, len = {}, 1900
        local count = math.ceil(#ret/len)>1 and math.ceil(#ret/len) or 1
        for i=1,count do
            result[i] = string.sub(ret, (len*(i-1)), (len*(i)))
        end
        for _,v in pairs(result) do
            if v ~= "" then message:reply({
                content = v,
                code = "lua"
            }) end
        end
    else
        message:reply("```Error loading function```")
    end
    print = oldPrint
end

return exec
