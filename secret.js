var STATE = [0,
             Qt.Key_Up, Qt.Key_Up,
             Qt.Key_Down, Qt.Key_Down,
             Qt.Key_Left, Qt.Key_Right,
             Qt.Key_Left, Qt.Key_Right];

var index = 0;

function succeedp(key) {
    index %= STATE.length;

    if (STATE[index + 1] === key)
        index++;
    else if (index === 2 && key === Qt.Key_Up)
        index = 2;
    else
        index = 0;

    return index === (STATE.length - 1);
}
