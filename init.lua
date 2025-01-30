require('config.lazy')


local test_dirs = vim.fs.find(
	{ 'node_modules' },
	{ limit = math.huge, type = 'directory', stop = 'node_modules' }
)[1]

print(vim.inspect(test_dirs))
