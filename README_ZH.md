# alfred-markdown-search

通过 Alfred Workflow 搜索和打开 Markdown 文档

## 文档

* [English document](REAMDME.md)
* [中文文档](README_ZH.md)


## 痛点

在使用 Typora 管理 Markdown 文档时，自带的搜索功能不是很好用，有些文档搜索不到。


## 参数设置

打开 `Markdown Search workflow` 的环境变量设置页面，配置如下环境变量：

* `MARKDOWN_PATH` -- `必填项` -- markdown文档所在目录路径，多个目录用英文冒号`:`分隔
* `MARKDOWN_APP` -- `可选项` -- 第三方App, 例如 `/Applications/Typora.app`

## 如何使用

关键词: `mdd` （也可以自定义该快捷键触发 workflow）

1. 不输入任何参数时，按照最近修改时间倒序展示20条文档记录；
2. 支持 `-t` (`title`)参数，对文档标题区域搜索（`标题区域`：为支持多种md文档格式，定义文档的 `前九行` 为标题区域来进行关键字查找）；
3. 支持输入多个关键字过滤，中间以空格分隔，关键字不区分大小写；
4. 选中对应行，`回车`，会用系统默认的markdown文档App打开该文档；
5. 选中对应行，按下 `Options + 回车`，会用自定义配置的第三方App打开该文档；


## 示例

```
# 不输入任何参数，按最近修改时间展示20条文档记录
mdd


# 在标题区域搜索关键词，关键词不区分大小写
mdd -t golang


# 全文搜索关键词，关键词不区分大小写
mdd golang


# 全文搜索关键词，多个关键词之间用空格分隔，关键词不区分大小写
mdd golang Python


# 查找标题区域含有 golang ，且文档内容中包含 python 的文档
mdd -t golang python


# 查找标题区域含有 golang 和 python 的文档
mdd -t golang,python


# 查找标题区域含有 golang 和 python 关键词，且文档内容中包含 mysql 的文档
mdd -t golang,python mysql
```


## 感谢

* [MWeb workflow](https://github.com/tianhao/alfred-mweb-workflow)
