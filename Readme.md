# QuickVideoEditor

# Description

QuickVideoEditor is a command-line tool designed to streamline video composition and editing. It processes a project file in JSON format, containing audio and video track data, and outputs a final composed video. The tool supports optional overwriting of output files and leverages the AVFoundation framework for handling media assets.

# Installation

- **Manual**
```
git clone https://github.com/obocat/quickvideoeditor.git .
make install
```

# Usage

## Options

- `-p, --project-file`  
  Required. The path to the JSON project file containing the video and audio data.

- `-o, --output-file`  
  Required. The path to save the composed video output.

- `--overwrite`  
  Required. Flag to overwrite the output file if it already exists.

## Example

```bash
quickvideoeditor -p ~/projects/myVideoProject.json -o ~/videos/output.mp4 --overwrite true
```

# Contributing

Contributions are welcome! Feel free to fork this repository, submit pull requests, and report issues.

# Acknowledgments

- **swift-argument-parser** for simplifying command-line argument parsing in *Swift*.

# Disclaimer

This tool is provided as-is, without any warranties or guarantees. Use at your own risk.
