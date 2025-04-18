# User Subscription Management System - Frontend

## Overview
This repository contains the frontend code for the **User Subscription Management System**, built using **Flutter**. The system enables users to manage their subscriptions, profiles, and authentication through an intuitive interface. It communicates with the backend (Flask) via API endpoints, handling user registration, login, subscription management, and profile updates.

## Features
- **User Authentication**: Secure login and registration using JWT-based authentication.
- **Subscription Management**: Users can subscribe to different plans (Basic, Premium) and view their subscription status.
- **Profile Management**: Allows users to view and update their profile details (e.g., name, city, state, GST number).
- **Admin Panel**: Admin users can view expired subscriptions for management purposes.
- **Responsive Design**: The app is built to work seamlessly on both iOS and Android devices.

## Project Setup

### Prerequisites
- Flutter SDK (at least version 2.x)
- Dart SDK
- A running instance of the backend (Flask) API

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/ImanImtiaz2001/Subscriptionsystem_Frontend.git
    cd Subscriptionsystem_Frontend
    ```

2. **Install dependencies**:
    Ensure that you have Flutter installed. Run the following command in the project directory:
    ```bash
    flutter pub get
    ```

3. **Run the application**:
    To run the application locally on your device or emulator, execute:
    ```bash
    flutter run
    ```

4. **Configure the backend API**:
    Ensure the Flask backend is running and properly configured. The frontend communicates with the backend API to handle user authentication, subscription management, and profile updates. You can run the backend locally on port `5000` by following the [Backend Setup](https://github.com/ImanImtiaz2001/Eliteit_backend).

### Folder Structure

/lib /screens # Flutter screen widgets (Login, Register, Profile, etc.) /providers # State management and API communication (AuthProvider, SubscriptionProvider) /models # Data models for user and subscription /utils # Helper classes and utilities /widgets # Custom UI components (buttons, form fields, etc.) /assets # Image and asset files /images /icons


### Screens
- **Login Screen**: Allows users to log in using email and password.
- **Register Screen**: Facilitates user registration with email, password, and confirm password.
- **Profile Screen**: Displays the user's profile information and allows profile updates.
- **Subscription Screen**: Enables users to subscribe to plans (Basic, Premium, Enterprise).
- **Admin Screen**: Displays expired subscriptions for admin users.

### Providers
- **AuthProvider**: Handles login, registration, and JWT token management.
- **SubscriptionProvider**: Manages subscription actions, such as subscribing to plans and viewing the active subscription status.

### UI/UX Design
- **Material Design**: The app follows Material Design guidelines, providing a consistent and polished user experience.
- **Responsive Layout**: The app uses Flutter’s responsive layout techniques to ensure compatibility across devices.

## API Endpoints
The frontend communicates with the backend API to perform various actions such as user authentication and subscription management. The following endpoints are used:
- `/register`: User registration
- `/login`: User login and token generation
- `/subscribe`: Subscribe to a plan
- `/profile`: Fetch user profile data
- `/update-profile`: Update user profile information
- `/admin`: Admin endpoint to view expired subscriptions

For detailed information on backend APIs, refer to the backend [documentation](https://github.com/ImanImtiaz2001/Eliteit_backend).

## Testing
- **Frontend Testing**: Manual testing of the UI components on Android and iOS devices.
- **API Communication**: Ensure all API calls (login, registration, subscription, profile) work as expected.

## Deployment
For deployment, follow the steps mentioned in the [Backend Deployment](https://github.com/ImanImtiaz2001/Eliteit_backend#deployment) section to deploy the backend. Once the backend is deployed, update the API endpoints in the Flutter app to the live backend URL.

## Contributions
Feel free to contribute by:
1. Forking the repository
2. Making changes or adding features
3. Creating a pull request

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- **Flutter**: For creating an amazing cross-platform framework.
- **JWT Authentication**: For secure authentication management.
- **Flask**: For building the backend RESTful API.

---

For more information, please refer to the [Backend Documentation](https://github.com/ImanImtiaz2001/Eliteit_backend).

