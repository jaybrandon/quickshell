pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: source?.audio?.muted ?? false
    readonly property real volume: source?.audio?.volume ?? 0
    readonly property string device: source?.description ?? "unknown"

    function setVolume(volume: real): void {
        if (source?.ready && source?.audio) {
            source.audio.muted = false;
            source.audio.volume = volume;
        }
    }

    function toggleMute(): void {
        if (source?.ready && source?.audio) {
            source.audio.muted = !muted;
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }
}
