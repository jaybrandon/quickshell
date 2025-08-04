import Quickshell.Io

JsonObject {
    property Apps apps: Apps {}

    component Apps: JsonObject {
        property list<string> terminal: ["foot"]
        property list<string> audio: ["pavucontrol", "-t", "1"]
        property list<string> microphone: ["pavucontrol", "-t", "4"]
    }
}
