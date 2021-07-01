local http = game:GetService('HttpService')
local Promise = require(script.Parent.Promise)

local function httpRequest(request)
        return http:RequestAsync({
                Url = request.url,
                Method = request.method,
                Headers = request.headers:entries(),
                Body = request.body,
        })
end

local function fetch(self, input, init)
        local Request, Response = self.Request, self.Response

        if type(input) == 'string' then
                input = Request.new(input, init)
        elseif Request.is(input) == false then
                error('Invalid request format', 2)
        end

        return Promise.new(function(resolve, reject)
                local ok, result = pcall(function()
                        return httpRequest(input)
                end)

                local response = {
                        ok = result.Success,
                        status = result.StatusCode,
                        statusText = result.StatusMessage,
                        headers = result.Headers,
                        body = result.Body,
                        url = input.url,
                }

                if ok then
                        resolve(Response.new(response))
                else
                        reject(result)
                end
        end)
end

return fetch