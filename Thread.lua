local Thread = {}

Thread._threads = {}

function Thread.new(name, fn)
	assert(type(name) == "string")
	assert(type(fn) == "function")

	if Thread._threads[name] then
		error("thread already exists")
	end

	Thread._threads[name] = {
		Name = name,
		Function = fn,
		Running = false
	}
end

function Thread.start(name, ...)
	local t = Thread._threads[name]
	if not t or t.Running then return end

	t.Running = true

	task.spawn(function(...)
		t.Function(...)
		t.Running = false
	end, ...)
end

function Thread.stop(name)
	local t = Thread._threads[name]
	if not t then return end

	t.Running = false
end

function Thread.join(name)
	local t = Thread._threads[name]
	if not t then return end

	while t.Running do
		task.wait()
	end
end

function Thread.exists(name)
	return Thread._threads[name] ~= nil
end

function Thread.remove(name)
	local t = Thread._threads[name]
	if not t then return end

	t.Running = false
	Thread._threads[name] = nil
end

return Thread
