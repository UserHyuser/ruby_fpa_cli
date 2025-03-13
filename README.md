# File Processor Application

A Ruby CLI application for processing image and PDF files to extract previews and text content.

## Features

- **File Processing**:
  - 🖼️ Image preview generation (PNG/JPEG → resized PNG)
  - 📄 PDF processing:
    - First page preview generation
    - Text content extraction (PDF → TXT)
- **Logging**:
  - JSON-formatted operation logs (app.log)
  - Detailed context for debugging
- **CLI Interface**:
  - Simple command options
  - Input validation
- **Docker Support**:
  - Containerized environment
  - Easy deployment

## Usage

```bash
  bin/file_processor -f INPUT_FILE [OPTIONS]
```

## Examples

1. Extract preview and text from PDF:
  `bin/file_processor -f document.pdf -c all`
2. Generate image preview only:
  `bin/file_processor -f image.jpg -c preview`
3. Extract text from PDF:
  `bin/file_processor -f document.pdf -c text`

## Requirements

- Ruby 3.2.2
- Bundler
- Docker
- ImageMagick

## Installation

```bash
git clone git@github.com:UserHyuser/ruby_fpa_cli.git
cd ruby_fpa_cli
bundle install
```

## Docker
### Build the Image
`docker build -t file-processor .`
### Run the application through docker image
`docker-compose run --rm file-processor -f /app/test.pdf -c all`

## Testing
`bundle exec rspec`

## Possible improvemetns
- Create CI/CD pipeline with rspec, rubocop, simplecov and building docker image
- YARD doc for every method

## License
MIT License