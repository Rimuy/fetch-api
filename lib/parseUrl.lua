
local function parseUrl(url)
        if url:sub(#url, #url) == '/' then
                url = url:sub(1, #url - 1)
        end
        if url:find('^http[s]?://') then
                return url
        end
        error('URL must include http:// or https:// at the beginning', 3)
end

return parseUrl