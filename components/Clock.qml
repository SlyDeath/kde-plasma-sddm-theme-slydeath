import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0

RowLayout {

    property int clockSize
    
    KeyboardButton {}
    Battery {}
    Label {
        font.family: config.Font || "Noto Sans"
        font.pointSize: clockSize
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], " ddd dd MMMM,")
        renderType: Text.QtRendering
    }
    Label {
        font.family: config.Font || "Noto Sans"
        font.pointSize: clockSize
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        renderType: Text.QtRendering
    }
    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}
