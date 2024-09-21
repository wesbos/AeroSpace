import AppKit
import Common

struct FullscreenCommand: Command {
    let args: FullscreenCmdArgs

    func _run(_ state: CommandMutableState, stdin: String) -> Bool {
        check(Thread.current.isMainThread)
        guard let window = state.subject.windowOrNil else {
            return state.failCmd(msg: noWindowIsFocused)
        }
        let newState: Bool = switch args.toggle {
            case .on: true
            case .off: false
            case .toggle: !window.isFullscreen
        }
        if newState == window.isFullscreen {
            state.stderr.append((newState ? "Already fullscreen. " : "Already not fullscreen. ") +
                "Tip: use --fail-if-noop to exit with non-zero code")
            return !args.failIfNoop
        }
        window.isFullscreen = newState
        window.noOuterGapsInFullscreen = args.noOuterGaps

        // Focus on its own workspace
        window.markAsMostRecentChild()
        return true
    }
}

let noWindowIsFocused = "No window is focused"