local Thread = {}

Thread._threads = {}

function Thread.new(name, fn)
	assert(type(name) == "string", "name must be string")
	assert(type(fn) == "function", "fn must be function")

	if Thread._threads[name] then
		error(("thread '%s' already exists"):format(name))
	end

	Thread._threads[name] = {
		Name = name,
		Function = fn,
		Alive = false
	}
end

function Thread.start(name)
	local thread = Thread._threads[name]

	if not thread or thread.Alive then
		return
	end

	thread.Alive = true

	task.spawn(function()
		while thread.Alive do
			thread.Function()
			task.wait()
		end
	end)
end

function Thread.stop(name)
	local thread = Thread._threads[name]

	if not thread then
		return
	end

	thread.Alive = false
end

function Thread.remove(name)
	local thread = Thread._threads[name]

	if not thread then
		return
	end

	thread.Alive = false
	Thread._threads[name] = nil
end

function Thread.exists(name)
	return Thread._threads[name] ~= nil
end

return Thread