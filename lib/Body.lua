local http = game:GetService('HttpService')
local Promise = require(script.Parent.Promise)

return {
        json = function(self)
                return Promise.defer(function(resolve)
                        resolve(http:JSONDecode(self.body))
                end)
        end,
        text = function(self)
                return Promise.defer(function(resolve)
                        resolve(http:JSONEncode(self.body))
                end)
        end,
}