$ = jQuery

Page = (target, opts) ->
	@target = target
	@opts = opts
	@currPage = opts.defPage
	@init()

Page:: = 
	init: ->
		that = @
		opts = that.opts

		wrap = that.pageWrap = $ '<div></div>'
		wrap.addClass opts.pageWrapClass
		that.createPage opts.defPage
		that.target.after wrap
		that.p
		that.bindEvent()
		return
	# html模板
	createPage: (curPage) ->
		that = @
		opts = that.opts
		tags = opts.tags
		total = opts.total*1 or 1
		curPage = curPage*1 or 1

		# 超过100页后
		# 按每2页刷新一次分页
		page = if total > 100 then 2 else 4
		# length
		# 如果当前页数，分页后超过
		# 总页数 使用总页数
		len = if curPage + page > total then total else curPage + page
		# 起点
		# 如果小于1 就是第一页
		i = if curPage - page < 1 then 1 else curPage - page

		arr = ['<em class="prev">\u4e0a\u4e00\u9875</em>']

		if curPage - page > 2
			arr.push '<em data-n="1">1</em><em class="no"> ... </em>'
		else if curPage - page is 2
			arr.push '<em data-n="1">1</em>'

		`for(;i <= len; i++){
			if (i == curPage){
				arr.push('<em data-n="'+i+'" class="current">'+i+'</em>')
			}else{
				arr.push('<em data-n="'+i+'">'+i+'</em>')
			}
		}`

		if curPage + page < total - 1
			arr.push "<em class=\"no\"> ... </em><em data-n=\"#{total}\">#{total}</em>"
		else if curPage + page is total - 1
			arr.push "<em data-n=\"#{total}\">#{total}</em>"

		arr.push '<em class="next">\u4e0b\u4e00\u9875</em>'

		that.pageWrap.html arr.join ''
	# 获取索引
	getIndex: (obj) ->
		index = @currPage
		if obj.hasClass 'next'
			index++
			if index > @opts.total
				return false
		else if obj.hasClass 'prev'
			index--
			if index < 1
				return false
		else 
			index = obj.attr 'data-n'
		return index | 0

	# 事件绑定
	bindEvent: ->
		that = @
		opts = that.opts
		that.pageWrap.delegate opts.tags, 'click', ->
			_this = $(@)
			index = that.getIndex _this
			if typeof index isnt 'number'
				return index

			that.currPage = index
			that.createPage index
			opts.callback and opts.callback index
			return
		return


# 默认参数
defaultConfig = 
	# 页码标签
	tags: 'em'
	# 盛放页码的容器
	pageWrapClass: 'pagenav' 
	# 当前的样式
	curClass: 'current'
	# 是否显示首页
	first: true
	# 是否显示尾页
	last: true
	# 默认当前是第几页
	defPage: 1
	# 总页数
	total: 5
	callback: ->

$.fn.pageNav = (opts) ->
	opts = $.extend {}, defaultConfig, opts

	new Page $(@), opts

	return