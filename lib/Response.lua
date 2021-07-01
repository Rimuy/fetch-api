local BodyMethods = require(script.Parent.Body)
local Headers = require(script.Parent.Headers)
local parseUrl = require(script.Parent.parseUrl)
local merge = require(script.Parent.merge)

local NONE = {}

local statusMessages = {
        [200] = 'OK',
        [201] = 'Created',
        [202] = 'Accepted',
        [400] = 'Bad Request',
        [401] = 'Unauthorized',
        [402] = 'Payment Required',
        [403] = 'Forbidden',
        [404] = 'Not Found',
        [500] = 'Internal Server Error',
        [501] = 'Not Implemented',
        [502] = 'Bad Gateway',
        [503] = 'Service Unavailable',
        [504] = 'Gateway Timeout',
}

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

        function Response.prototype:error()
                return self:redirect(self.url, 400)
        end

        function Response.prototype:redirect(url, status)
                url = parseUrl(url)

                return Response.new(
                        merge(self:clone(), {
                                url = url,
                                status = status or self.status,
                                statusText = statusMessages[status] or 'Unknown',
                        }),
                        { headers = self.headers }
                )
        end
end

return Response