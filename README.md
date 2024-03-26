# wevo-frontend

A new Flutter project.

## Assumptions

The following assumptions made in the development process:
1. Created main page widget (and state) to conroller and handle the all the parts needed for this app (input, sumbit buttton, seggestions and RSS Feed widget)
2. Created RSS feed widget to display all the feeds coming from the server by search value (account or channel)
3. Created View RSS feed widget to display each feed in a seperate page (with back button to return to main page)
4. In regards to RSS feed, I tried to handle the different data structure coming from the server response (can be with items or without) and image can be taken from different places (try to handle it as well)
5. The main strugle was the communication between main page (input, submit button and suggestions) to the RSS feed but I made it work by passing the input value as a parameter and updatee state
6. It was great experince learning Flutter (hope I did good and follow best practices) and once you understand it it can be fun :)

## Requirements

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Running the application locally

After install Flutter cmd tools (see documentation above), you can run the app (starting from the project library) like so:

```shell
flutter run
```

