# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Rails engine that integrates Cloudinary image hosting with Alchemy CMS. It replaces Alchemy's default Dragonfly storage with Cloudinary's cloud-based image service, allowing images to be stored on Cloudinary and rendered with on-demand transformations.

## Architecture

### Core Integration Points

**Engine Initialization** (`lib/alchemy_cloudinary/engine.rb`)
- Registers a custom Dragonfly datastore (`:alchemy_cloudinary`)
- Configures Alchemy to use the Dragonfly storage adapter
- Overrides `Alchemy::StorageAdapter::Dragonfly.picture_url_class` to use `CloudinaryUrl`

**Storage Layer**
- `DragonflyDataStore`: Handles upload/download/destroy operations via Cloudinary API
- `StorePictureThumb`: No-op class - thumbnails aren't stored because Cloudinary renders them on-demand
- `CloudinaryUrl`: Generates Cloudinary URLs with transformation parameters (crop, resize, format, etc.)

### Key Behavior

The `CloudinaryUrl` class inherits from `Alchemy::StorageAdapter::Dragonfly::PictureUrl` and overrides URL generation to:
1. Build transformation arrays from options (crop, resize)
2. Calculate crop coordinates from `crop_from` and `crop_size`
3. Call `picture.image_file.remote_url()` with Cloudinary transformation syntax
4. Support modes: `fill` (crop), `fit` (upsample), `limit` (default)

## Commands

### Testing

```bash
# Run all tests
bundle exec rake spec
# or
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/alchemy/storage_adapter/dragonfly/cloudinary_url_spec.rb

# Run with specific seed for reproducibility
bundle exec rspec --seed 12345
```

### Development

```bash
# Install dependencies
bundle install

# Build gem
gem build alchemy_cloudinary.gemspec

# Install locally built gem
gem install alchemy_cloudinary-*.gem
```

## Test Setup

Tests load only the minimal Alchemy CMS classes needed:
- Uses `active_support/core_ext/object/blank` for `.present?` method
- Loads `Alchemy::StorageAdapter::Dragonfly::PictureUrl` parent class directly
- No full Rails initialization or dummy app required
- Tests use RSpec doubles for `picture` and `image_file` objects

The test helper (`spec/rails_helper.rb`) manually sets up the load path to require the actual Alchemy parent class, then loads the CloudinaryUrl subclass.

## Dependencies

- **Alchemy CMS**: >= 8.0.0.c, < 9.0
- **Cloudinary**: ~> 2.0
- **Ruby**: 3.4.7 (see `.ruby-version`)

## Configuration

Users need to configure Cloudinary credentials via:
- `CLOUDINARY_URL` environment variable (recommended for production)
- `config/cloudinary.yml` file (should be gitignored)
- Rails initializer at `config/initializers/cloudinary.rb`

The gem automatically configures Alchemy to use this storage adapter when loaded.
