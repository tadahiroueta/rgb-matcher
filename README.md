# RGB Matcher
***A quick and simple colour matching game***

[Built With](#built-with) · [Features](#features) · [Installation](#installation) · [Usage](#usage)

## Built With

- ![UIkit](https://img.shields.io/badge/uikit-2581d0?style=for-the-badge&logo=uikit&logoColor=white)
- ![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
- ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
- ![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

## Features

### Colour algorithm
The player is prompted with a random colour (RGB value) and is tasked to adjust the sliders to recreate the colour. The lower the mean distance between the RGB values, the higher the score.

<img src="https://github.com/tadahiroueta/rgb-matcher/blob/main/samples/upright.gif" alt="upright" width="248rem" />

> Made entirely programatically

### High Score retention
The player's high score is stored locally and will be accessible whenever the user plays again.

### Dynamic sideways display
Constraints are set to dynamically update when the iPhone is turned to its side for more comfort

![sideways](https://github.com/tadahiroueta/rgb-matcher/blob/main/samples/sideways.gif)

### Figma prototype
The app was first planned on [Figma](https://www.figma.com/design/F8Sw9hue24SfOALI4S9ZAw/rbg-matcher?node-id=5-148&t=AvIXuaNoBwBrb7Cn-1)

![figma](https://github.com/tadahiroueta/rgb-matcher/blob/main/samples/figma.png)

## Installation

1. Install [Xcode](https://developer.apple.com/xcode/)

2. Clone repository
    - Open Xcode
    - "Clone an existing project"
    - Enter ```https://github.com/tadahiroueta/rgb-matcher.git```

## Usage

1. Run the iOS simulator by clicking the ```▶``` button

2. Adjust the sliders to change the colour of the top circle, and try to get the closest to the bottom circle before the timer runs out. 
