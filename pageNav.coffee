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
		tmp = that.createPage opts.defPage

		wrap = that.pageWrap = $ '<div></div>'
		wrap.addClass opts.pageWrapClass
		wrap.html tmp
		that.target.after wrap
		that.p
		that.bindEvent()
		return
	# html模板
	createPage: (curPage) ->
		that = @
		opts = that.opts
		tags = opts.tags
		pHide = nHide = ''
		if curPage <= 1
			pHide = 'hide'
		if curPage >= opts.total
			nHide = 'hide'
		tagFirst = "<#{tags} data-n=\"1\" class=\"first\">首页</#{tags}>"
		tagString = """
		<#{tags} class=\"prev #{pHide}\">上一页</#{tags}>
		"""
		`for (var i=0; i<opts.total; i++){
			var cla = '';
			if((i+1) === curPage){
				cla = opts.curClass
			}
			tagString += '<' + tags + ' data-n="'+(i+1)+'" class="' + cla + '">' + (i+1) + '</'+tags+'>';
		}`
		tagString += """
		<#{tags} class=\"next #{nHide}\">下一页</#{tags}>		
		"""
		tagLast = "<#{tags} data-n=\"#{opts.total}\" class=\"last\">尾页</#{tags}>"

		if opts.first
			tagString = tagFirst + tagString
		if opts.last
			tagString += tagLast		

		return tagString
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

	# 上一页下一页显示隐藏
	pNSH: (index) ->
		pageWrap = @pageWrap
		if index <= 1
			pageWrap.find('.prev').addClass 'hide'
			pageWrap.find('.next').removeClass 'hide'
			return
		else if index >= @opts.total
			pageWrap.find('.next').addClass 'hide'
			pageWrap.find('.prev').removeClass 'hide'
			return
		pageWrap.find('.next').removeClass 'hide'
		pageWrap.find('.prev').removeClass 'hide'
		return
	# 事件绑定
	bindEvent: ->
		that = @
		opts = that.opts
		that.pageWrap.delegate opts.tags, 'click', ->
			_this = $(@)
			index = that.getIndex _this
			if typeof index isnt 'number'
				return index

			that.pNSH index


			that.currPage = index
			that.pageWrap.children().eq(1+index).addClass(opts.curClass).siblings().removeClass(opts.curClass)
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
