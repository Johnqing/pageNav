分页插件
=======


## 调用

```
$('elem').pageNav({
	// 页码标签
	tags: 'em',
	// 盛放页码的容器
	pageWrapClass: 'pagenav' ,
	// 当前的样式
	curClass: 'current',
	// 是否显示首页
	first: true,
	// 是否显示尾页
	last: true,
	// 默认当前是第几页
	defPage: 1,
	// 总页数
	total: 5,
	callback: function(){}
});
```
![pagenav](https://github.com/Johnqing/pageNav/blob/master/demo.png)
