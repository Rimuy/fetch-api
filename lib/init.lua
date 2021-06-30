return setmetatable({
        Body = require(script.Body),
        Headers = require(script.Headers),
        Request = require(script.Request),
        Response = require(script.Response),
}, {
        __call = require(script.fetch),
})