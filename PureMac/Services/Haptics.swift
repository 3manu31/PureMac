import AppKit

/// Thin wrapper around `NSHapticFeedbackManager` so call sites don't have to
/// reach into AppKit. Only Force Touch trackpads produce a click; on other
/// hardware the calls are no-ops, which is the documented behavior.
///
/// We deliberately use the system performer rather than spinning up a custom
/// haptic engine — the standard patterns (alignment / levelChange / generic)
/// already match what users expect from Apple's own apps.
enum Haptics {
    /// Light tick — use for transient UI feedback like advancing a page or
    /// flipping a toggle. Cheapest of the three.
    static func tap() {
        perform(.alignment)
    }

    /// Stronger affirmation — use when a user-visible state change crosses a
    /// boundary (Full Disk Access granted, scan completed, clean finished).
    static func success() {
        perform(.levelChange)
    }

    /// Generic feedback — fallback when nothing else fits.
    static func generic() {
        perform(.generic)
    }

    private static func perform(_ pattern: NSHapticFeedbackManager.FeedbackPattern) {
        NSHapticFeedbackManager.defaultPerformer.perform(pattern, performanceTime: .now)
    }
}
