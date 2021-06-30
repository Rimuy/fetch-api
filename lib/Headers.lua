local INVALID_HEADER_ENTRY_FORMAT = 'Entry must be a table of 2 values: {%s, %s}'

local Headers do
        Headers = { prototype = {} }
        Headers.prototype.__index = Headers.prototype

        function Headers._new(init)
                for i, t in ipairs(init) do
                        if #t ~= 2 then
                                error(
                                        (INVALID_HEADER_ENTRY_FORMAT):format(
                                                t[1] and ('"%s"'):format(t[1]) or 'Name',
                                                t[2] and ('"%s"'):format(t[2]) or 'Value'
                                        ),
                                        3
                                )
                        end

                        init[t[1]] = t[2]
                        table.remove(t, i)
                end

                return setmetatable(init, Headers.prototype)
        end

        function Headers.new(init)
                return Headers._new(init)
        end

        function Headers.Is(obj)
                return (type(obj) == 'table' and getmetatable(obj) == Headers.prototype)
        end

        function Headers.prototype:__tostring()
                return '<Headers>'
        end

        function Headers.prototype:_count()
                local n = 0
                self:forEach(function(_, i)
                        n = i
                end)

                return n
        end

        function Headers.prototype:delete(name)
                self[name] = nil
        end

        function Headers.prototype:_entries()
                local entries = table.create(0)
                for k, v in pairs(self) do
                        if type(v) == 'string' then
                                entries[k] = v
                        end
                end

                return entries
        end

        function Headers.prototype:entries()
                return self:_entries()
        end

        function Headers.prototype:forEach(callback)
                for k, v in pairs(self:_entries()) do
                        callback(v, k, self)
                end
        end

        function Headers.prototype:get(name)
                return self:_entries()[name]
        end

        function Headers.prototype:has(name)
                return self:get(name) ~= nil
        end

        function Headers.prototype:keys()
                local n = self:_count()

                local keys = table.create(n)
                for k, _ in pairs(self:_entries()) do
                        table.insert(keys, k)
                end

                return keys
        end

        function Headers:set(name, value)
                self[name] = value
        end

        function Headers:values()
                local n = self:_count()

                local values = table.create(n)
                for _, v in pairs(self:_entries()) do
                        table.insert(values, v)
                end

                return values
        end
end

return Headers