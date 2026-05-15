local Thread = {}

Thread._threads = {}

function Thread.new(name, fn)
	assert(type(name) == "string", "Name must be a string")
	assert(type(fn) == "function", "Function must be a function")

	if Thread._threads[name] then
		error("thread already exists")
	end

	Thread._threads[name] = {
		Name = name,
		Function = fn,
		Running = false,
		ThreadObject = nil
	}
end

function Thread.start(name, ...)
	local t = Thread._threads[name]
	if not t or t.Running then return end

	t.Running = true

	t.ThreadObject = task.spawn(function(...)
		t.Function(...)
		t.Running = false
		t.ThreadObject = nil
	end, ...)
end

function Thread.stop(name)
	local t = Thread._threads[name]
	if not t then return end

	t.Running = false

	if t.ThreadObject then
		pcall(task.cancel, t.ThreadObject)
		t.ThreadObject = nil
	end
end

function Thread.join(name)
	local t = Thread._threads[name]
	if not t then return end

	while t.Running and t.ThreadObject do
		task.wait()
	end
end

function Thread.exists(name)
	return Thread._threads[name] ~= nil
end

function Thread.remove(name)
	local t = Thread._threads[name]
	if not t then return end

	if t.Running then
		Thread.stop(name)
	end
	
	Thread._threads[name] = nil
end

return Thread
