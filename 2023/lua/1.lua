---@param haystack table
---@param needle string
---@return boolean
local function in_array(needle, haystack)
    local num_needle = tonumber(needle)
    for digit, _ in pairs(haystack) do
        if num_needle == digit then
            return true
        end
    end
    return false
end

local digits = {
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
}

local function lookup_tree(numbers)
    local output = {}
    for k, v in pairs(numbers) do
        if output[tostring(k)] == nil then
            output[tostring(k)] = k
        end
        local pointer = output
        for i = 1, #v do
            local c = string.sub(v, i, i)

            if pointer[c] == nil then
                if i == string.len(v) then
                    pointer[c] = k
                else
                    pointer[c] = {}
                end
            end
            pointer = pointer[c]
        end
    end
    return output
end

local digit_lookup = lookup_tree(digits)

local sum = 0

for line in io.lines("../input/1") do
    local first = nil
    local last = nil
    local match = nil

    local open_look_ups = {}
    for i = 1, #line do
        local c = string.sub(line, i, i)
        local new_open_look_ups = {}

        for _, v in ipairs(open_look_ups) do
            match = v[c]

            if match ~= nil then
                if type(match) == "number" then
                    if first == nil then
                        first = match
                    end
                    last = match
                    goto continue
                else
                    table.insert(new_open_look_ups, match)
                end
            end
        end

        open_look_ups = new_open_look_ups
        match = digit_lookup[c]

        if match ~= nil then
            if type(match) == "number" then
                if first == nil then
                    first = match
                end
                last = match
            else
                table.insert(open_look_ups, match)
            end
        end
        ::continue::
    end

    print(line, tonumber(first .. last))

    sum = sum + tonumber(first .. last)
end

print(sum)
