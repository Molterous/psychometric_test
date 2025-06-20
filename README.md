# 🚆 Psychometric Test

A Flutter-based visual-motor reaction time test that simulates a train approaching a tunnel. The user must stop the train as accurately as possible when it aligns with the tunnel. This is inspired by psychometric assessments used in fields like cognitive science, driver training, and attention evaluation.

# 🧠 Overview

This test is designed to measure:

- Visual perception
- Reaction time
- Spatial accuracy
- Symmetrical attention (with left/right variation)

Each round randomly presents the train either from the left or the right, and the user must stop it over the tunnel by tapping or pressing the spacebar.

# 🎮 Features

- 🚂 Train moves from either side randomly.
- 🕹️ User interaction via tap or keyboard.
- 🧮 Scoring system based on proximity to the tunnel (1 to 10 points).
- 🔁 10 rounds per session with visual feedback.
- 🎨 Custom canvas rendering using CustomPainter.
- 🔄 Reusable widget architecture for train direction variations.

# 📦 Installation

1. Clone the repository:

   git clone https://github.com/your-username/psychometric_test.git
   cd psychometric_test

2. Get dependencies:

   flutter pub get

3. Run the app:

   flutter run

# 🛠️ Tech Stack

- Flutter
- Custom animation with AnimationController
- Image rendering with dart:ui
- Game logic via CustomPainter and StatefulWidget

# 👨‍💻 Author

- Aakash Choudhary (Molterous)

> Feel free to reach out or fork this for learning or experimentation!
