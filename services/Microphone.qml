pragma Singleton

import qs.config
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: source?.audio?.muted ?? false
    readonly property real volume: source?.audio?.volume ?? 0
    readonly property string device: source?.description ?? "unknown"

    function setVolume(newVolume: real): void {
        if (source?.ready && source?.audio) {
            source.audio.muted = false;
            source.audio.volume = Math.max(0, Math.min(1, newVolume));
        }
    }

    function toggleMute(): void {
        if (source?.ready && source?.audio) {
            source.audio.muted = !muted;
        }
    }

    function incrementVolume(amount: real): void {
        setVolume(volume + (amount || Config.services.audioIncrement));
    }

    function decrementVolume(amount: real): void {
        setVolume(volume - (amount || Config.services.audioIncrement));
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }
}
