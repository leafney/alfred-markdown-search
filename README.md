# alfred-markdown-search

Alfred Workflow for search and open Markdown files

## Documents

* [English document](REAMDME.md)
* [Chinese document](README_ZH.md)


## Pain Point

When using Typora to manage markdown documents, the built-in search function is not very useful. Some documents cannot be searched.


## Params Setting

Open the environment variable setting page of `Markdown Search workflow`, and configure:

* `MARKDOWN_PATH` -- `Required` -- Directory path of markdown files
* `MARKDOWN_APP` -- `Optional` -- Third-party apps, such as `/Applications/Typora.app`

## How to use

Keyword: `mdd` (you can also customize this shortcut to trigger workflow)


1. When no parameters are entered, 20 document records are displayed in reverse order according to the latest modification time;
2. Support the `-t` (`title`) parameter to search the title area of the document (`title area`: to support multiple md document formats, define the `first nine lines` of the document as the title area for keyword search) ；
3. Support inputting multiple keywords to filter, separated by spaces, keywords are not case sensitive;
4. Select the corresponding line and press `Enter` to open the document with the system default markdown document App;
5. Select the corresponding line and press `Options + Enter`, the document will be opened with a custom-configured third-party App;


## Examples

```
# By default, 20 document records are displayed according to the latest modification time
mdd


# Search keywords in the title area, the keywords are not case sensitive
mdd -t golang


# Full text search keywords, keywords are not case sensitive
mdd golang


# Full text search keywords, multiple keywords are separated by spaces, keywords are not case sensitive
mdd golang Python


# Find documents that contain `golang` in the title area and `python` in the content of the document
mdd -t golang python


# Find documents with `golang` and `python` in the title area
mdd -t golang,python


# Find documents that contain `golang` and `python` keywords in the title area and `mysql` in the document content
mdd -t golang,python mysql
```


## Thanks

* [MWeb workflow](https://github.com/tianhao/alfred-mweb-workflow)
