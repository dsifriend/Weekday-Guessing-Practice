#!/bin/bash

pickdate() {
    year=$(($RANDOM-$RANDOM))

    local isleap
    if [[ $(($year % 400)) -eq 0 ]]; then
        isleap=true
    elif [[ $(($year % 100)) -eq 0 ]]; then
        isleap=false
    elif [[ $(($year % 4)) -eq 0 ]]; then
        isleap=true
    else
        isleap=false
    fi

    month=$(($RANDOM % 12))
    local monthdays
    if [[ $isleap && $month -eq 1 ]]; then
        monthdays=29
    else
        case $month in
            0|2|4|6|7|9|11)
                monthdays=31
                ;;
            3|5|8|10)
                monthdays=30
                ;;
            1)
                monthdays=28
        esac
    fi

    day=$(($RANDOM % $monthdays))
}

displaydate() {
    local display_year
    if [[ $year -le 0 ]]; then
        display_year="$(($year*-1 + 1))BCE"
    else
        display_year="$(($year))CE"
    fi

    local display_month
    case $month in
        0)
            display_month="Jan"
            ;;
        1)
            display_month="Feb"
            ;;
        2)
            display_month="Mar"
            ;;
        3)
            display_month="Apr"
            ;;
        4)
            display_month="May"
            ;;
        5)
            display_month="Jun"
            ;;
        6)
            display_month="Jul"
            ;;
        7)
            display_month="Aug"
            ;;
        8)
            display_month="Sep"
            ;;
        9)
            display_month="Oct"
            ;;
        10)
            display_month="Nov"
            ;;
        11)
            display_month="Dec"
    esac

    local display_day="$(($day + 1))"

    printf "%s %s, %s" "$display_month" "$display_day" "$display_year"
}

wday() {
    local adjustment=$(((14-($month +1)) / 12))
    local mm=$((($month + 1) + 12*$adjustment - 2))
    local yy=$(($year-$adjustment))

    echo $(( ( ($day + 1) + (13 * $mm - 1) / 5 + \
		$yy + $yy / 4 - $yy / 100 + $yy / 400) % 7 ))
}

continue_prompt=true
while $continue_prompt; do
    # Choose a random date and ask user for day of the week, then check
    pickdate
    printf "What day of the week was %s %s %s? (0 is Sunday)\n" $(displaydate)
    read answer
    if [[ $answer -ne $(wday) ]]; then
        echo "Sorry, incorrect."
    else
        echo "Congrats, that's correct!"
    fi

    # Check whether to restart
    prompt="?"
    while [[ $prompt =~ [^yn] ]]; do
        echo "Do you want to try again? (y/n)"
        read prompt
    done
    if [[ $prompt == "n" ]]; then
        continue_prompt=false
    fi
    prompt="?"
done
