local BodyMethods = require(script.Parent.Body)
local Headers = require(script.Parent.Headers)
local merge = require(script.Parent.merge)
local parseUrl = require(script.Parent.parseUrl)

local INVALID_REQUEST_FORMAT = 'Input should be of type string'
local NONE = {}

local Request do
        Request = { prototype = {} }
        Request.prototype.__index = Request.prototype

        local defaultRequestInit = {
                method = 'GET',
                body = nil,
        }

        function Request.new(input, init)
                if type(input) ~= 'string' then
                        error(INVALID_REQUEST_FORMAT, 2)
                end

                local url = parseUrl(input)
                init = merge(defaultRequestInit, init)

                if init.headers == nil then
                        init.headers = NONE
                end

                local headers = Headers.Is(init.headers)
                        and init.headers or Headers.new(init.headers)

                return setmetatable({
                        body = init.body,
                        bodyUsed = init.body ~= nil,
                        headers = headers,
                        method = init.method,
                        url = url,
                }, Request.prototype)
        end

        function Request.Is(obj)
                return (type(obj) == 'table' and getmetatable(obj) == Request.prototype)
        end

        function Request.prototype:__tostring()
                return '<Request>'
        end

        function Request.prototype:clone()
                local copy = table.create()
                for k, v in pairs(self) do
                        copy[k] = v
                end

                return setmetatable(copy, Request.prototype)
        end

        function Request.prototype:json()
                return BodyMethods.json(self)
        end

        function Request.prototype:text()
                return BodyMethods.text(self)
        end
end

return Request