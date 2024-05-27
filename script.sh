#!/bin/bash

# Get all pdf files in the current directory

files=$(ls *.pdf)

# ITパスポートは命名規則が違う
function ip() {
    regex='([0-9]{4})([hr])([0-9]{2})([hao])_ip_(qs|ans|cmnt).pdf'
    [[ $1 =~ $regex ]]
    newname="IPA_IP_"
    
    case ${BASH_REMATCH[2]} in
        h)
            newname+='平成'
            ;;
        r)
            newname+='令和'
            ;;
    esac

    newname+=${BASH_REMATCH[3]}

    case ${BASH_REMATCH[4]} in
        h)
            newname+='春_'
            ;;
        a)
            newname+='秋_'
            ;;
        o)
            newname+='代_' # 2020年度のみ(春中止のため)
            ;;
    esac

    # タイプ
    case ${BASH_REMATCH[5]} in
        qs)
            newname+='問題'
            ;;
        ans)
            newname+='解答'
            ;;
        cmnt)
            newname+='講評'
            ;;
    esac

    echo "(IP) $file -> $newname.pdf"

    # 暗号化を解除 + コピー
    qpdf --decrypt $file ./result/$newname.pdf
}

for file in $files
do
    # generate new filename
    newname='IPA_' # prefix
    
    # 後で手動で操作するファイルを除外(特別試験など)
    if [[ $file == *tokubetsu* ]]; then # 2011 特別試験
        mv $file ./_manual/
        continue
    fi
    if [[ $file == *youkou* ]]; then
        mv $file ./_manual/
        continue
    fi
    if [[ $file == *topic* ]]; then
        mv $file ./_manual/
        continue
    fi

    # ITパスポート(命名規則が違う)
    if [[ $file == *ip* ]]; then
        ip $file
        continue
    fi

    # 試験年度
    regex='([0-9]{4})([hr])([0-9]{2})([hao])_(.*)_(.*)_(qs|ans|cmnt).pdf'
    [[ $file =~ $regex ]]

    # 試験区分(移植)
    case ${BASH_REMATCH[5]} in
        st)
            newname+='ST_'
            ;;
        sa)
            newname+='SA_'
            ;;
        pm)
            newname+='PM_'
            ;;
        nw)
            newname+='NW_'
            ;;
        db)
            newname+='DB_'
            ;;
        es)
            newname+='ES_'
            ;;
        sm)
            newname+='SM_'
            ;;
        au)
            newname+='AU_'
            ;;
        sc)
            newname+='SC_'
            ;;
        ap)
            newname+='AP_'
            ;;
        fe)
            newname+='FE_'
            ;;
        sg)
            newname+='SG_'
            ;;
        koudo)
            newname+='SP_'
            ;;
    esac

    case ${BASH_REMATCH[2]} in
        h)
            newname+='平成'
            ;;
        r)
            newname+='令和'
            ;;
    esac

    newname+=${BASH_REMATCH[3]}

    case ${BASH_REMATCH[4]} in
        h)
            newname+='春_'
            ;;
        a)
            newname+='秋_'
            ;;
        o)
            newname+='_' # 2020年度のみ(春中止のため)
            ;;
    esac

    # 時間記号
    case ${BASH_REMATCH[6]} in
        am)
            newname+='午前_'
            ;;
        pm)
            newname+='午後_'
            ;;
        am1)
            newname+='午前1_'
            ;;
        am2)
            newname+='午前2_'
            ;;
        pm1)
            newname+='午後1_'
            ;;
        pm2)
            newname+='午後2_'
            ;;
    esac

    # タイプ
    case ${BASH_REMATCH[7]} in
        qs)
            newname+='問題'
            ;;
        ans)
            newname+='解答'
            ;;
        cmnt)
            newname+='講評'
            ;;
    esac

    echo "$file -> $newname.pdf"

    # 暗号化を解除 + コピー
    qpdf --decrypt $file ./result/$newname.pdf

done
