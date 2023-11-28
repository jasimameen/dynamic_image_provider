# Flutter Package: DynamicImageBuilder

DynamicImageBuilder is a Flutter package that allows you to fetch and display the favicon of a website.

## Features

- Fetches the favicon from a given URL.
- Displays the favicon as an image.

## Installation

Add the following line to your `pubspec.yaml` file:

yaml dependencies: dynamic_image_builder: ^latest_version

Replace `latest_version` with the latest version of the package.

Then, run the following command in your terminal:

bash flutter pub get


## Usage

To use DynamicImageBuilder, import the package in your Dart file:

dart import 'package:dynamic_image_builder/dynamic_image_builder.dart';


You can use the `DynamicImageBuilder.fromWebUrlFav` method to fetch and display the favicon of a website. Here is an example:

dart DynamicImageBuilder.fromWebUrlFav(webUrl: "https://flutter.dev")


In this example, the method fetches the favicon from the Flutter website and displays it.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Contact

If you have any questions or suggestions, feel free to contact me.

- GitHub: [jasimameen](https://github.com/jasimameen)
- LinkedIn: [jasimameen](https://linkedin.com/in/jasimameen)