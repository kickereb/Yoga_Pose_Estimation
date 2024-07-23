# Yoga Pose Estimator

## Description
The Yoga Pose Estimator is an interactive application that utilizes the PoseNet model to track and analyze a user's pose in real-time. By comparing the user's pose landmarks to predefined yoga poses, the application provides feedback on the user's alignment and form. This project integrates with RunwayML for pose tracking and outputs the results to the Processing development environment for a user-friendly visualization.

## Features
- **Real-Time Pose Estimation**: Uses PoseNet to track the user's pose landmarks in real-time.
- **Yoga Pose Recognition**: Compares the user's pose to a database of yoga poses, starting with the warrior pose as a demonstrated example.
- **Visualization**: Displays the pose estimation and alignment feedback in the Processing development environment.
![](https://github.com/kickereb/Yoga_Pose_Estimation/blob/master/src/Preview (2) (1).gif)

## Installation
To set up the Yoga Pose Estimator, follow these steps:
1. Install RunwayML from [RunwayML's website](https://runwayml.com/).
2. Clone this repository to your local machine.
3. Open the project in RunwayML and link it to the Processing development environment as per the instructions given in the `installation_guide.md`.

## Usage
1. Start the PoseNet model within RunwayML.
2. Execute the Processing sketch to open the user interface.
3. Follow the on-screen instructions to align your pose with the yoga pose example.
4. Receive real-time feedback on your pose and make adjustments as recommended.
![](https://github.com/kickereb/Yoga_Pose_Estimation/blob/master/src/warrior_pose.gif)

## Contributing
If you would like to contribute to the Yoga Pose Estimator, please fork the repository and submit a pull request with your proposed changes.

## License
This project is released under the MIT License. See the `LICENSE` file for more information.

## Credits
- PoseNet Model: Provided by RunwayML.
- Processing Development Environment: For creating accessible visual feedback.
