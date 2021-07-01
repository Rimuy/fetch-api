local BodyMethods = require(script.Parent.Body)
local Headers = require(script.Parent.Headers)
local parseUrl = require(script.Parent.parseUrl)
local merge = require(script.Parent.merge)

local NONE = {}

local Response do
        Response = { prototype = {} }
        Response.prototype.__index = Response.prototype

        function Response.new(body, init)
                if type(body) ~= 'table' then
                        body = NONE
                end

                if type(init) ~= 'table' then
                        init = NONE
                end

                if init.headers ~= nil and Headers.is(init.headers) == false then
                        init.headers = Headers.new(init.headers)
                end

                body = merge(body, BodyMethods, init)

                return setmetatable(body, Response.prototype)

        end

        function Response.prototype:__tostring()
                return '<Response>'
        end

        function Response.prototype:clone()
                local copy = table.create(0)
                for k, v in pairs(self) do
                        copy[k] = v
                end

                return setmetatable(copy, Response.prototype)
        end

        function Response.prototype:doError()
                return self:redirect(self.url, 400)
        end

        function Response.prototype:redirect(url, status)
                url = parseUrl(url)

                return Response.new(
                        merge(self:clone(), {
                                url = url,
                                status = status or self.status,
                        }),
                        { headers = self.headers }
                )
        end
end

return Response