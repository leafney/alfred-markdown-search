#!/usr/bin/env bash

# MARKDOWN_PATH="${HOME}/demo"
# NOTE: 

if [ -z "${MARKDOWN_PATH}" ];then
   echo "{ \"items\":[{\"type\": \"error\",\"title\": \"请先设置文档路径 MARKDOWN_PATH \"}]}"
   exit 1
fi

# echo "11--${MARKDOWN_PATH}"


declare -a header_arr # 标题数组
declare -a keyword_arr # 关键字数组
next_input=0 # 下一步输入参数归类，0:keyword, 1: title
last_input=0 # 最后一次输入的参数归类；与next_input 相同
end_option=1 #　是否终止了除 keyword 以外类型的参数输入: 单最后一个字符为空格表示输出完成了
end_char="" # 最后一个参数最后输入的字符

get_params(){
    while [ $# -gt 0 ]; do
        case "$1" in
            -t)
#                echo "$1"
                next_input=1
                last_input=${next_input}
                shift;;
            *)
#                echo "$1"
                str=${1//，/,} # 中文逗号改成英文逗号
                n=${#str}
                end_char=${str:$((n-1))} # 记录最后一个字符
                # 按照 next_input 指示，将参数放到对应的数组中。
                case "${next_input}" in
                    1) IFS=","; for i in ${str};do header_arr+=("$i"); done;unset IFS ;;
                    *) keyword_arr+=("$str") ;;
                esac
                last_input=${next_input} # 保存最后一次输入的参数类型
                next_input=0;
                shift;;
        esac
    done
}

get_params $*

final_expr=""
IFS=":";for i in ${MARKDOWN_PATH}
do
    final_expr="${final_expr} find \"${i}\" -type f -iname '*.md';"
done
unset IFS
final_expr="{${final_expr}}"
#final_expr="{${final_expr}} | xargs -I'{}' stat -f'%m %N' '{}' | sort -rn | cut -d' ' -f 2-"  # | xargs -I'{}' grep -l tomcat '{}"

# echo "57--${final_expr}"
# echo "header_arr:${header_arr} -- keyword_arr:${keyword_arr} -- next_input:${next_input} -- last_input:${last_input} -- end_char:${end_char}"


# 如果有输入-h参数，过滤文档标题
# 思路: grep -n 会输出行号，找到符合所有关键字的行，筛选行号=1的文档就可以了
if [ ${#header_arr[@]} -gt 0 ];then
    final_expr="${final_expr} | xargs -I'{}' grep -inHe '${header_arr[0]}' '{}'"
    for i in ${header_arr[@]:1}
    do
        final_expr="${final_expr} | grep -ie '${i}'"
    done
    # 匹配文档前九行符合条件的文档
    final_expr="${final_expr} | egrep '^.+\.md\:[1-9]\:' | awk -F':' '{print \$1}'"
fi

# echo "73--${final_expr}"


# 如果有输入关键字，则用关键字筛选文档，并且按照文档标题匹配度排序
if [ ${#keyword_arr[@]} -gt 0 ];then
    for i in ${keyword_arr[@]}
    do
        final_expr="${final_expr} | xargs -I'{}' grep -ile '${i}' '{}' | awk -F':' '{print \$1}' | uniq "
    done

    # echo "83--${final_expr}"

    # 按时间排序
    # final_expr="${final_expr} | xargs -I'{}' stat -f'%m %N' '{}' | sort -rn | cut -d' ' -f 2- "
    final_expr="${final_expr} | xargs -I'{}' ls -t '{}'"

    # 排序表达式: 统计第一行匹配关键字个数，将匹配个数大的放在前面
    # 第一步: 输入"文件名",输出"文件名 匹配个数"
    # 第二步: 按照 "匹配个数" 倒序排序
    # 第三步: 去掉 "匹配个数" 字段，只保留"文件名"
    # 由于ls -lt 是按照编辑时间倒序排序的，所以最终排序等级：标题匹配个数倒序->最后编辑倒序
    egrep_expr=$(echo "${keyword_arr[@]}" | sed "s/[[:blank:]]/|/g")
    sort_expr="awk -F'\\n' '{system(\"egrep -ioe \\\"${egrep_expr}\\\" <<< \`head -1 \\\"\"\$1 \"\\\"\` | wc -l | xargs -I\\\"{}\\\" echo \\\"{}\\\" \\\"\"\$1\"\\\"\")}' | sort -r | cut -d' ' -f 2-"
    final_expr="${final_expr} | ${sort_expr} "
else
    # 按时间排序
    # final_expr="${final_expr} | xargs -I'{}' stat -f'%m %N' '{}' | sort -rn | cut -d' ' -f 2- "
    final_expr="${final_expr} | xargs -I'{}' ls -t '{}'"
fi

final_expr="${final_expr} | head -20" # 取前20个

# echo "106--${final_expr}"

result="{\"items\":["
n=0
r=0
while read line
do
#    echo line=${line}

    # 将文件名作为结果列表中的标题显示
    h="${line##*/}"
    result+="{\"type\": \"file\",\"title\": \"${h}\",\"subtitle\": \"${line}\",\"arg\": \"${line}\"},"
    n=$((n+1))
done < <(eval "${final_expr}")
if [ ${n} -eq 0 ]; then
    result+="{\"title\": \"没有找到符合条件的文档\"}"
fi

# Remove the json str last comma
if [ ${r} -eq 0 ]; then
    result=${result%,}
fi

result+="]}"
echo ${result}