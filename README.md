# AlchemyCMS Cloudinary Integration

Cloudinary is a cloud service that offers a solution to a web application's entire image management pipeline.

* Easily upload images to the cloud.
* Automatically perform smart image resizing, cropping and conversion without installing any complex software.
* Images are seamlessly delivered through a fast CDN, and much much more.

## Usage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alchemy_cloudinary', github: 'AlchemyCMS/alchemy_cloudinary'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install alchemy_cloudinary
```

## Configuration

To use the Cloudinary Ruby on Rails library, you have to configure at least:

* `cloud_name`
* `api_key`
* `api_secret`

Setting the configuration parameters can be done by:

* programmatically in each call to a Cloudinary method
* globally using config/cloudinary.yml configuration file

  > **Warning**: In this case you must **exclude it** from version control system (git, etc). In `.gitignore` you can add `config/cloudinary.yml`

* use a Rails initializer file.

  You can place a file named `cloudinary.rb` in the `config/initializers` folder of your Rails project.

  Here's some sample initializer code:

  ```ruby
  # config/initializer/cloudinary.rb
  Cloudinary.config do |config|
    config.cloud_name = 'sample'
    config.api_key = '874837483274837'
    config.api_secret = 'a676b67565c6767a6767d6767f676fe1'
    config.secure = true
    config.cdn_subdomain = true
  end
  ```

* dynamically configure the `cloud_name`, `api_key`, and `api_secret` by defining the `CLOUDINARY_URL` environment variable.

  The **configuration URL** is available in the Management Console's dashboard of your account.
  When using Cloudinary through a PaaS add-on (e.g., **Heroku**), this environment variable is
  **automatically** defined in your deployment environment.

  Here's a sample value:

  `CLOUDINARY_URL=cloudinary://874837483274837:a676b67565c6767a6767d6767f676fe1@sample`

  > **Note**: If you use more than one configuration option, the order of precedence is:
  `CLOUDINARY_URL` -> `cloud_name` -> `cloudinary.yml`

## Resources

* https://cloudinary.com/documentation/rails_integration
* Sample projects - https://github.com/cloudinary/cloudinary_gem/tree/master/samples
  * Basic Ruby sample.
    Uploading local and remote images to Cloudinary and generating various transformation URLs.
  * Basic Rails sample.
    Uploading local and remote images in a Rails project while embedding various transformed images in a Rails web view.
  * Rails Photo Album.
   A fully working web application.
   It uses CarrierWave to manage images of an album model (database).
   Performs image uploading both from the server side and directly from the browser using a jQuery plugin.
* https://rubygems.org/gems/cloudinary
* https://github.com/cloudinary/cloudinary_gem
* https://cloudinary.com/documentation/rails_image_and_video_upload
* https://cloudinary.com/documentation/rails_image_manipulation

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
