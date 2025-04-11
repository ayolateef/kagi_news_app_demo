# News Aggregator

A Flutter-based mobile app that aggregates news articles from the Kite API, allowing users to browse, favorite, and listen to news through text-to-speech (TTS) or audio streams.

# Features
- News Browsing**: View clustered articles by category (e.g., Tech, World) from the Kite API.
- Favorites**: Save articles to a persistent favorites list using `shared_preferences`.
- Text-to-Speech**: Listen to article titles and summaries with Play/Stop TTS controls.
- Audio Streaming**: Play news-related audio streams (via RadioBrowser API) with Play/Stop controls.
- Responsive Design**: Adapts to all screen sizes using `flutter_screenutil`.
- Theme Support**: Toggle between light and dark modes.

## Tech Stack
- *Framework**: Flutter (Dart)
- *State Management**: Provider
- *HTTP Requests**: `http` for API calls
- *Storage**: `shared_preferences` for favorites persistence
- *TTS**: `flutter_tts` for text-to-speech
- *Audio**: `just_audio` for streaming
- *Dependencies**:
    - `flutter_screenutil: ^5.9.0`
    - `provider: ^6.0.0`
    - `http: ^1.1.0`
    - `intl: ^0.18.0`
    - `flutter_tts: ^3.8.0`
    - `just_audio: ^0.9.36`
    - `shared_preferences: ^2.2.0`

## Setup
1. **Prerequisites**:
    - Flutter SDK (v3.19.x recommended)
    - Android Studio / Xcode
    - Git

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/ayolateef/kagi_news_app_demo.git
   cd kagi_news_app_demo
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the App**:
   ```bash
   flutter run
   ```
    - Use a physical device for reliable TTS and audio streaming (emulators may lack audio support).

## Usage
- **Home Screen**: Browse articles by category using the category selector.
- **Favorites Screen**: Tap the heart icon on articles to save/remove them (persists across restarts).
- **Explore Screen**: Placeholder for future features.
- **Article Details**: Tap an article to view details in a bottom sheet with TTS and streaming options.

## Notes
- **Kite API**: Provides article metadata (title, link, etc.) and clusters; full content is mocked.
- **Audio Streams**: Uses RadioBrowser API (`https://all.api.radio-browser.info`) for news-related streams.
- **TTS**: May require `flutter clean` and a physical device if `MissingPluginException` occurs.

## Future Enhancements
- Add full-text article extraction (e.g., via Diffbot API).
- Display article clusters instead of a flat list.
- Enhance audio with progress bars and TTS with voice selection.

## License
MIT License - free to use, modify, and distribute.

---

Built by Ayolateef with Flutter.