# Stateful Login (Stream/BLoC)

A Flutter project demonstrating state management using both `StatefulWidget` and the **BLoC Pattern with RxDart** through a Login screen example.

![Login Screen Demo](login_stateful_video.gif)

---

## Table of Contents

- [Overview](#overview)
- [State Management in Flutter](#state-management-in-flutter)
- [Project Structure](#project-structure)
- [Widget Hierarchy](#widget-hierarchy)
- [Key Concepts](#key-concepts)
  - [StatefulWidget](#statefulwidget)
  - [State Class](#state-class)
  - [Mixins](#mixins)
- [BLoC Pattern Implementation (src2)](#bloc-pattern-implementation-src2)
  - [Technologies Used](#technologies-used)
  - [BLoC Architecture](#bloc-architecture)
  - [RxDart & BehaviorSubject](#rxdart--behaviorsubject)
  - [InheritedWidget (Provider)](#inheritedwidget-provider)
  - [StreamBuilder for Reactive UI](#streambuilder-for-reactive-ui)
  - [Stream-Based Validation](#stream-based-validation)
  - [BLoC Code Walkthrough](#bloc-code-walkthrough)
- [Widgets Used](#widgets-used)
- [Properties & Methods](#properties--methods)
- [Form Validation](#form-validation)
- [Code Walkthrough](#code-walkthrough)

---

## Overview

This project serves as a learning resource for understanding how to build stateful applications in Flutter. It provides **two implementations** of the same Login screen:

### 1. StatefulWidget Approach (`lib/src/`)
- Creating and managing state with `StatefulWidget`
- Form handling and validation using `Form` widget
- Using mixins for code reusability

### 2. BLoC Pattern with RxDart (`lib/src2/`)
- Reactive state management using **Streams** and **RxDart**
- Business Logic Component (BLoC) pattern for separation of concerns
- Custom `InheritedWidget` as a Provider
- `StreamBuilder` for reactive UI updates
- Stream-based validation using `StreamTransformer`

---

## State Management in Flutter

| Approach | Description | Best For | Example in Project |
|----------|-------------|----------|-------------------|
| `StatefulWidget` | Built-in Flutter approach, easier to understand | Small to medium apps, learning | `lib/src/` |
| `BLoC` Pattern | Separates business logic using Streams | Large, complex applications | `lib/src2/` |

### Why BLoC?

- **Separation of Concerns**: UI code doesn't contain business logic
- **Testability**: BLoC can be unit tested independently of Flutter
- **Reusability**: Same BLoC can power multiple UIs
- **Predictable**: Data flows in one direction (unidirectional data flow)

---

## Project Structure

```
lib/
├── main.dart                    # Entry point - runApp()
├── src/                         # StatefulWidget implementation
│   ├── app.dart                 # Root widget (MaterialApp)
│   ├── mixins/
│   │   └── validator_mixin.dart # Validation logic (reusable)
│   └── screens/
│       └── login_screen.dart    # StatefulWidget login screen
│
└── src2/                        # BLoC Pattern implementation
    ├── my_app.dart              # Root widget with Provider
    ├── blocs/
    │   ├── bloc.dart            # BLoC class (business logic)
    │   └── providers.dart       # InheritedWidget provider
    ├── mixins/
    │   └── validators_mixin.dart # StreamTransformer validators
    └── screens/
        └── login_screen.dart    # StatelessWidget with StreamBuilder
```

---

## Widget Hierarchy

### StatefulWidget Approach (`src/`)

```
App (StatelessWidget)
└── MaterialApp
    └── Scaffold
        └── LoginScreen (StatefulWidget)
            └── Container
                └── Form
                    └── Column
                        ├── TextFormField (Email)
                        ├── TextFormField (Password)
                        ├── SizedBox (Spacing)
                        └── ElevatedButton (Submit)
```

### BLoC Pattern Approach (`src2/`)

```
Provider (InheritedWidget) ─── provides ───► Bloc instance
└── MyApp (StatelessWidget)
    └── MaterialApp
        └── Scaffold
            └── LoginScreen (StatelessWidget)
                └── Container
                    └── Center
                        └── Column
                            ├── StreamBuilder<String> (Email)
                            │   └── TextField
                            ├── StreamBuilder<String> (Password)
                            │   └── TextField
                            └── StreamBuilder<bool> (Login Button)
                                └── ElevatedButton
```

---

## Key Concepts

### StatefulWidget

A widget that has mutable state. It's composed of two classes:

1. **StatefulWidget class** - Immutable, creates the State object
2. **State class** - Mutable, holds the state and builds the UI

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() {
    return LoginScreenState();
  }
}
```

**Key Points:**
- `createState()` method returns a new instance of the State class
- The widget itself is immutable; only the State object changes
- State persists across rebuilds until the widget is removed from the tree

### State Class

The State class is where the actual logic and mutable data lives:

```dart
class LoginScreenState extends State<LoginScreen> with ValidationMixin {
  // Mutable state
  String email = '';
  String password = '';
  
  @override
  Widget build(BuildContext context) {
    // Returns the UI
  }
}
```

**Key Points:**
- Extends `State<T>` where `T` is the StatefulWidget type
- Contains the `build()` method that returns the widget tree
- State changes trigger UI rebuilds via `setState()` (not used here since form handles state internally)

### Mixins

Mixins allow code reuse across multiple classes. Think of it as "copy-pasting" methods into a class.

```dart
mixin ValidationMixin {
  String? validateEmail(String? value) { ... }
  String? validatePassword(String? value) { ... }
}

// Usage: "with" keyword
class LoginScreenState extends State<LoginScreen> with ValidationMixin {
  // Now has access to validateEmail() and validatePassword()
}
```

**Why use Mixins?**
- Avoid code duplication
- Share functionality across unrelated classes
- Dart doesn't support multiple inheritance, mixins are the solution

---

## BLoC Pattern Implementation (src2)

The `lib/src2/` directory demonstrates a **reactive approach** to state management using the BLoC (Business Logic Component) pattern with RxDart.

### Technologies Used

| Technology | Purpose | Package |
|------------|---------|---------|
| **RxDart** | Reactive extensions for Dart Streams | `rxdart: ^0.28.0` |
| **BehaviorSubject** | Special StreamController that caches the latest value | Part of RxDart |
| **StreamTransformer** | Transform/validate stream data | Dart core |
| **InheritedWidget** | Dependency injection (custom Provider) | Flutter core |
| **StreamBuilder** | Rebuild UI reactively on stream updates | Flutter core |

### BLoC Architecture

The BLoC pattern separates business logic from UI:

```
┌─────────────────────────────────────────────────────────────────┐
│                           UI Layer                              │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ LoginScreen (StatelessWidget)                           │    │
│  │  - Uses StreamBuilder to listen to streams              │    │
│  │  - Calls bloc methods on user interaction               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Provider (InheritedWidget)                              │    │
│  │  - Holds Bloc instance                                  │    │
│  │  - Provides Bloc to widget tree via Provider.of()      │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Business Logic Layer                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Bloc class                                               │    │
│  │  - BehaviorSubject<String> for email                    │    │
│  │  - BehaviorSubject<String> for password                 │    │
│  │  - Streams with validation transforms                   │    │
│  │  - Rx.combineLatest2 for form validity                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ ValidatorsMixin                                         │    │
│  │  - StreamTransformer for email validation              │    │
│  │  - StreamTransformer for password validation           │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### RxDart & BehaviorSubject

**BehaviorSubject** is a special type of `StreamController` from RxDart that:
- Caches the **latest emitted value**
- Immediately emits the cached value to new listeners
- Useful when you need to access the current value synchronously

```dart
import 'package:rxdart/rxdart.dart';

class Bloc with ValidatorsMixin {
  // BehaviorSubject caches the latest value
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // Expose transformed streams (with validation)
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  // Combine multiple streams to determine form validity
  Stream<bool> get isLoginValid =>
      Rx.combineLatest2(email, password, (emailValue, passwordValue) => true);

  // Sinks to add data to streams
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Access cached values directly
  void login() {
    print('Email: ${_emailController.valueOrNull}, Password: ${_passwordController.valueOrNull}');
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
```

**Key RxDart Features Used:**

| Feature | Description |
|---------|-------------|
| `BehaviorSubject<T>` | StreamController with cached latest value |
| `.valueOrNull` | Access the current cached value (nullable) |
| `Rx.combineLatest2()` | Combines two streams, emits when either updates |

### InheritedWidget (Provider)

A custom `InheritedWidget` provides the BLoC instance to the entire widget tree:

```dart
class Provider extends InheritedWidget {
  Provider({super.key, required super.child});

  final bloc = Bloc();  // Holds the single BLoC instance

  @override
  bool updateShouldNotify(_) => true;

  // Static method to retrieve the Bloc from context
  static Bloc of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<Provider>()!.bloc;
  }
}
```

**Usage:**
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(  // Wrap the app with Provider
      child: MaterialApp(
        home: Scaffold(body: LoginScreen()),
      ),
    );
  }
}

// In any descendant widget:
final bloc = Provider.of(context);  // Get the Bloc instance
```

### StreamBuilder for Reactive UI

`StreamBuilder` rebuilds its child widget whenever the stream emits a new value:

```dart
Widget emailField(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.email,  // Listen to email stream
    builder: (context, snapshot) {
      return TextField(
        decoration: InputDecoration(
          // Show validation error from stream
          errorText: snapshot.error as String?,
          hintText: 'you@example.com',
          labelText: 'Email address',
        ),
        onChanged: bloc.changeEmail,  // Push new value to stream
      );
    },
  );
}
```

**StreamBuilder Snapshot Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `snapshot.data` | `T?` | The latest data from the stream |
| `snapshot.hasData` | `bool` | Whether data has been received |
| `snapshot.error` | `Object?` | The latest error (if any) |
| `snapshot.hasError` | `bool` | Whether an error has occurred |
| `snapshot.connectionState` | `ConnectionState` | Current connection state |

### Stream-Based Validation

Validation is implemented using `StreamTransformer` in the mixin:

```dart
mixin ValidatorsMixin {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);       // Valid: forward the value
      } else {
        sink.addError('Invalid e-mail');  // Invalid: emit error
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 4) {
        sink.add(password);    // Valid: forward the value
      } else {
        sink.addError('Password too short');  // Invalid: emit error
      }
    },
  );
}
```

**Validation Flow:**

```
User types in TextField
        ↓
onChanged triggers bloc.changeEmail(value)
        ↓
Value added to BehaviorSubject sink
        ↓
Stream emits value through validateEmail transformer
        ↓
    ┌────────────────────────────────────┐
    │ Contains '@'? → sink.add(email)    │
    │ Invalid? → sink.addError(message)  │
    └────────────────────────────────────┘
        ↓
StreamBuilder rebuilds with new snapshot
        ↓
    ┌────────────────────────────────────┐
    │ snapshot.data → Show valid state   │
    │ snapshot.error → Show error text   │
    └────────────────────────────────────┘
```

### BLoC Code Walkthrough

#### 1. Root Widget (`my_app.dart`)

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Login BLoC Demo',
        home: Scaffold(body: LoginScreen()),
      ),
    );
  }
}
```

- Wraps `MaterialApp` with `Provider` to inject the BLoC

#### 2. Login Screen (`screens/login_screen.dart`)

```dart
class LoginScreen extends StatelessWidget {  // Note: StatelessWidget!
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);  // Get BLoC from Provider
    
    return Container(
      margin: const EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          children: [
            emailField(bloc),
            passwordField(bloc),
            loginButton(bloc),
          ],
        ),
      ),
    );
  }
}
```

- **StatelessWidget** because state lives in the BLoC, not the widget
- Gets the BLoC instance via `Provider.of(context)`

#### 3. Login Button with Conditional Enable

```dart
Widget loginButton(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.isLoginValid,  // Combined stream of email + password
    builder: (context, snapshot) {
      return ElevatedButton(
        // Button enabled only when both fields are valid
        onPressed: snapshot.hasData ? bloc.login : null,
        child: Text('Login'),
      );
    },
  );
}
```

- Button is **disabled** (`onPressed: null`) until both email and password are valid
- `Rx.combineLatest2` ensures `isLoginValid` only emits when both streams have valid data

---

### StatefulWidget vs BLoC Comparison

| Aspect | StatefulWidget (`src/`) | BLoC Pattern (`src2/`) |
|--------|------------------------|------------------------|
| **State Location** | Inside `State` class | Separate `Bloc` class |
| **UI Widget Type** | `StatefulWidget` | `StatelessWidget` |
| **Validation** | Sync functions returning `String?` | `StreamTransformer` with sink |
| **Error Display** | `TextFormField.validator` | `StreamBuilder` + `snapshot.error` |
| **Form Widget** | `Form` with `GlobalKey` | No `Form` widget needed |
| **Reactivity** | `setState()` triggers rebuild | `StreamBuilder` listens to streams |
| **Testability** | Harder (coupled to UI) | Easier (logic isolated in BLoC) |
| **Complexity** | Lower | Higher (more boilerplate) |
| **Best For** | Simple forms | Complex apps, shared state |

---

## Widgets Used

### 1. MaterialApp

The root widget that provides Material Design styling.

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Application title (shown in task switcher) |
| `home` | `Widget` | The default route's widget |

### 2. Scaffold

Provides the basic Material Design visual structure.

| Property | Type | Description |
|----------|------|-------------|
| `body` | `Widget` | Primary content of the scaffold |

### 3. Container

A convenience widget that combines padding, margins, constraints, and decoration.

| Property | Type | Description |
|----------|------|-------------|
| `margin` | `EdgeInsets` | Empty space around the container |
| `child` | `Widget` | The widget inside the container |

### 4. Form

Groups and validates form fields together.

| Property | Type | Description |
|----------|------|-------------|
| `key` | `GlobalKey<FormState>` | Identifies the form and allows access to its state |
| `child` | `Widget` | The form content (usually a Column) |

### 5. Column

Arranges children vertically.

| Property | Type | Description |
|----------|------|-------------|
| `children` | `List<Widget>` | List of widgets to display vertically |

### 6. TextFormField

A text input field integrated with `Form` for validation.

| Property | Type | Description |
|----------|------|-------------|
| `decoration` | `InputDecoration` | Visual styling (label, hint, borders) |
| `keyboardType` | `TextInputType` | Type of keyboard to show |
| `obscureText` | `bool` | Hides text (for passwords) |
| `obscuringCharacter` | `String` | Character to show when obscured |
| `validator` | `String? Function(String?)` | Validation function |
| `onSaved` | `void Function(String?)` | Called when form is saved |

### 7. InputDecoration

Defines the appearance of a `TextFormField`.

| Property | Type | Description |
|----------|------|-------------|
| `labelText` | `String` | Label that floats when focused |
| `hintText` | `String` | Placeholder text |

### 8. SizedBox

A box with a specific size, used for spacing.

| Property | Type | Description |
|----------|------|-------------|
| `height` | `double` | Fixed height in pixels |
| `width` | `double` | Fixed width in pixels |

### 9. ElevatedButton

A Material Design elevated button.

| Property | Type | Description |
|----------|------|-------------|
| `onPressed` | `VoidCallback` | Called when button is tapped |
| `style` | `ButtonStyle` | Visual styling |
| `child` | `Widget` | Button content (usually Text) |

---

## Properties & Methods

### GlobalKey&lt;FormState&gt;

```dart
final formKey = GlobalKey<FormState>();
```

A special key that uniquely identifies the Form widget and provides access to its state.

**Methods on `formKey.currentState`:**

| Method | Description |
|--------|-------------|
| `validate()` | Runs all validators, returns `true` if all pass |
| `save()` | Calls `onSaved` on each form field |
| `reset()` | Resets all form fields to initial values |

### TextInputType

Controls the keyboard layout shown to the user:

| Type | Description |
|------|-------------|
| `TextInputType.emailAddress` | Email keyboard with @ and .com |
| `TextInputType.text` | Standard text keyboard |
| `TextInputType.number` | Numeric keyboard |
| `TextInputType.phone` | Phone number keyboard |

### ButtonStyle & WidgetStatePropertyAll

```dart
style: ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.blue)
)
```

`WidgetStatePropertyAll` applies the same value for all button states (pressed, hovered, disabled, etc.).

---

## Form Validation

### How Validation Works

1. **Define validators** - Functions that return `null` for valid input, or an error message string for invalid input

```dart
String? validateEmail(String? value) {
  if (value != null && value.isNotEmpty) {
    if (!value.contains('@')) {
      return 'Please enter a valid email';  // Error message
    }
  }
  return null;  // Valid
}
```

2. **Attach validators to fields** - Use the `validator` property

```dart
TextFormField(
  validator: validateEmail,  // Reference to validation function
)
```

3. **Trigger validation** - Call `formKey.currentState?.validate()`

```dart
if (formKey.currentState?.validate() ?? false) {
  // All fields are valid
  formKey.currentState?.save();  // Triggers onSaved callbacks
}
```

### Validation Flow Diagram

```
User taps Login button
        ↓
formKey.currentState?.validate()
        ↓
Each TextFormField's validator runs
        ↓
    ┌───────────────────────────────┐
    │ Returns null? → Field valid   │
    │ Returns String? → Show error  │
    └───────────────────────────────┘
        ↓
All valid? → formKey.currentState?.save()
        ↓
Each onSaved callback fires → Values stored in state
```

---

## Code Walkthrough

### Entry Point (`main.dart`)

```dart
void main() {
  runApp(App());
}
```

- `runApp()` inflates the given widget and attaches it to the screen

### Root Widget (`app.dart`)

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Scaffold(body: LoginScreen()),
    );
  }
}
```

- `StatelessWidget` because it has no mutable state
- Sets up the Material app shell

### Login Screen (`login_screen.dart`)

**State Variables:**
```dart
final formKey = GlobalKey<FormState>();  // Form identifier
String email = '';                        // Stores email after save
String password = '';                     // Stores password after save
```

**Build Method:**
```dart
@override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(20.0),
    child: Form(
      key: formKey,
      child: Column(
        children: [
          emailField(),
          passwordField(),
          const SizedBox(height: 25.0),
          submitButton(),
        ],
      ),
    ),
  );
}
```

**Submit Handler:**
```dart
onPressed: () {
  final isFormValid = formKey.currentState?.validate() ?? false;
  
  if (isFormValid) {
    formKey.currentState?.save();
    debugPrint('Email: $email, Password: $password');
  }
}
```

### Validation Mixin (`validator_mixin.dart`)

```dart
mixin ValidationMixin {
  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!value.contains('@')) {
        return 'Please enter a valid email';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 4) {
        return 'Password must be at least 4 characters';
      }
    }
    return null;
  }
}
```

---

## Key Learnings

### StatefulWidget Approach
1. **StatefulWidget Pattern**: Separation of immutable widget definition and mutable state management
2. **Form Handling**: Using `GlobalKey<FormState>` to coordinate form validation and data collection
3. **Mixins**: Reusable code without inheritance hierarchy constraints
4. **Widget Composition**: Building complex UIs by composing simple widgets
5. **Null Safety**: Using `?` and `??` operators for safe null handling

### BLoC Pattern Approach
6. **Reactive Programming**: Using Streams for data flow instead of imperative `setState()`
7. **RxDart**: Leveraging `BehaviorSubject` for cached stream values and `combineLatest` for stream combination
8. **StreamTransformer**: Transforming and validating stream data before it reaches the UI
9. **InheritedWidget**: Manually implementing the Provider pattern for dependency injection
10. **StreamBuilder**: Building reactive UIs that automatically update when streams emit new values
11. **Separation of Concerns**: Keeping business logic (BLoC) separate from presentation (widgets)

---

## Dependencies

Add these to your `pubspec.yaml` for the BLoC implementation:

```yaml
dependencies:
  flutter:
    sdk: flutter
  rxdart: ^0.28.0  # For BehaviorSubject and Rx operators
```

---

## Running the Examples

To run the **StatefulWidget** version:
```dart
// In main.dart
import 'src/app.dart';
void main() => runApp(App());
```

To run the **BLoC Pattern** version:
```dart
// In main.dart
import 'src2/my_app.dart';
void main() => runApp(MyApp());
```

---

## License

This project is for educational purposes.

---

## Appendix: Stream Examples

### Stream example 1

```dart
import 'dart:async';

class Order {
  Order(this.typeOfCake);

  String typeOfCake;
}

class Cake {}

void main() {
  final controller = new StreamController();
  // Creates
  // 1. Sink: To add values (order taker)
  // 2. Stream: Main processing

  // 1. Created order of customer
  final order = new Order('d');

  // 4. Baker who bakes the cake
  final baker = new StreamTransformer.fromHandlers(
    handleData: (cakeType, sink) {
      if (cakeType == 'chocolate') {
        sink.add(new Cake());
      } else {
        sink.addError('I cannot bake that type!');
      }
    },
  );

  // 2. Hand the order to order taker and hands it to stream
  controller.sink.add(order);

  // 3. Order inspector
  controller.stream
      .map((order) {
        // Order inspector just reads the type
        return order.typeOfCake;
      })
      .transform(baker) // 4.1. Baker decides the type and produces the cake
      .listen( // 5. Listen for stream
        (cake) {
          print('Here is your $cake');
        },
        onError: (err) {
          print(err);
        },
      );
}
```

### Stream example 2

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Stream demo', home: MainScreen());
  }
}

class Input {
  Input({required this.value, this.result});
  
  Input.copyWith(Input input) :
    value = input.value,
    result = input.result;  

  int value;
  bool? result;
  
  @override
  String toString() {
    return '{value: $value, result: $result}';
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int counter = 0;

  final StreamController<Input> controller = StreamController<Input>();

  final StreamTransformer<Input, Input> transformer =
      StreamTransformer<Input, Input>.fromHandlers(
        handleData: (input, sink) {
          if (input.value % 2 == 0) {
            input.result = true;
            sink.add(Input.copyWith(input));
          } else {
            input.result = false;
            sink.addError(input);
          }
        },
      );

  @override
  void initState() {
    super.initState();

    controller.stream
        .timeout(
          new Duration(seconds: 1),
          onTimeout: (sink) => sink.addError('You lost!')
        )
        .transform(transformer)
        .listen((value) => print(value), onError: (err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              counter++;
            });
            controller.sink.add(Input(value: counter));
          },
          child: const Text('Click me'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
```