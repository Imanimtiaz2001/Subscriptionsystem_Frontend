import 'dart:convert';
import 'admin_page.dart';
import 'subscribe_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  final String accessToken;

  const ProfilePage({super.key, required this.accessToken});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller Definitions
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final gstNumberController = TextEditingController();

  // Color and Style Definitions
  final textColor = const Color(0xFF333333);
  final primaryColor = const Color(0xFFC4C7FA);
  final borderColor = const Color(0xFFF3F3F3);
  final subscriptionColor = const Color(0xFF444444);


  bool isEditing = false;  // Flag to toggle between editing and viewing mode
  bool showEditProfileIcon = true; // Flag to control the visibility of the edit icon
  bool showSubscription = true; // Flag to control the visibility of the active subscription section
  bool isLoading = true;  // To show loading indicator while fetching data
  Map<String, dynamic> profileData = {};  // Store profile data here


  @override
  void initState() {
    super.initState();
    fetchProfileData(widget.accessToken);  // Use the accessToken passed from the login page
  }
// Ensure the controllers are populated with profile data
  void updateControllers() {
    nameController.text = profileData['name'] ?? '';
    addressController.text = profileData['email'] ?? '';
    cityController.text = profileData['city'] ?? '';
    stateController.text = profileData['state'] ?? '';
    pinCodeController.text = profileData['pin_code'] ?? '';
    gstNumberController.text = profileData['gst_number'] ?? '';
  }
  Future<void> fetchProfileData(String accessToken) async {
    setState(() {
      isLoading = true;  // Start loading indicator
    });

    // Call authentication function to get profile data
    var result = await Provider.of<AuthProvider>(context, listen: false)
        .getProfileData(accessToken);  // Use the accessToken directly passed from login page

    // Log the result for debugging purposes
    print('Response: $result'); // Log the actual response

    // Check if the result is an error message or the actual profile data
    if (result is String) {
      // If result is a string, show an error dialog
      showDialogBox(context, result);  // Show error dialog if fetching fails
    } else {
      setState(() {
        profileData = result != null ? result : {};  // Make sure to handle null response
        isLoading = false;  // Hide loading indicator once data is fetched
      });
      updateControllers();
    }
  }
  Future<void> showDialogBox(BuildContext context, String message) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message), // This will show the error message from the backend
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildProfileText(),
            const SizedBox(height: 15),
            _buildProfileForm(context),
          ],
        ),
      ),
    );
  }

  // Header with logo and icons (search, notification, hamburger)
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(left: 15, right: 5, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Text
          Row(
            children: [
              Image.asset(
                'assets/images/logo.PNG', // Replace with your logo path
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Text(
                "LOGO",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          // Icons for Search, Notification, and Hamburger with reduced spacing
          Row(
            mainAxisSize: MainAxisSize.min, // Minimize the space between icons
            children: [
              IconButton(
                icon: Icon(Icons.search, color: textColor),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications, color: textColor),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: textColor),
                onSelected: (String value) {
                  if (value == 'admin') {
                    // Navigate to the ProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPage(accessToken: widget.accessToken),
                      ),
                    );
                  } else if (value == 'logout') {
                    // Show the logout confirmation dialog
                    _showLogoutDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> menuItems = [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ];

                  // Add the admin option only if the email is admin@example.com
                  if (profileData['email'] == 'admin@example.com') {
                    menuItems.insert(
                      0,
                      PopupMenuItem<String>(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                    );
                  }

                  return menuItems;
                },
                offset: Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
// Call logout function from AuthProvider
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);  // Close the dialog
                // Call logout from AuthProvider
                await Provider.of<AuthProvider>(context, listen: false)
                    .logoutUser(widget.accessToken, context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  // Profile Text header
  Widget _buildProfileText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the profile form UI
  Widget _buildProfileForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo Section inside the form
          _buildProfilePhotoSection(),
          const SizedBox(height: 15),
          Text(
            "Details",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField("Name", profileData['name'] ?? '', isEditing),
          const SizedBox(height: 16),
          _buildTextField("Address", profileData['email'] ?? '', false),
          const SizedBox(height: 16),
          _buildTextField("City", profileData['city'] ?? '', isEditing),
          const SizedBox(height: 16),
          _buildTextField("State", profileData['state'] ?? '', isEditing),
          const SizedBox(height: 16),
          _buildTextField("Pin Code", profileData['pin_code'] ?? '', isEditing),
          const SizedBox(height: 16),
          _buildTextField("GST Number", profileData['gst_number'] ?? '', isEditing),
          const SizedBox(height: 24),
          if (isEditing) _buildButtonsRow(context),
          const SizedBox(height: 24),
          if (showSubscription) _buildActiveSubscription(),
        ],
      ),
    );
  }

  // Profile Photo Section inside the Profile Form
  Widget _buildProfilePhotoSection() {
    return Row(
      children: [
        // Profile Photo Circle with Primary Color Background
        CircleAvatar(
          radius: 40,
          backgroundColor: primaryColor,  // Set the background color to primary color
          backgroundImage: profileData['profile_photo'] != null && profileData['profile_photo'] != ""
              ? NetworkImage(profileData['profile_photo'])  // Use the profile photo if it exists
              : AssetImage('assets/images/defaultphoto.PNG') as ImageProvider,  // Replace with the user's photo
        ),
        const SizedBox(width: 15),
        // Profile Text Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  profileData['name'] ?? 'Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 45),
                if (showEditProfileIcon)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditing = true;  // Show the input fields and button row
                        showEditProfileIcon = false;  // Hide the icon
                        showSubscription = false;  // Hide active subscription section
                      });
                    },
                    child: Image.asset(
                      'assets/images/profileedit.PNG',  // Replace with the actual image path
                      width: 24,  // Set the size of the image
                      height: 24,
                    ),
                  ),
              ],
            ),
            // "Registered User" inside a gray rectangular container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],  // Gray background
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                "Registered User",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Update your profile information",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildTextField(String label, String value, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 15),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getControllerForField(label), // Use the respective controller
          style: const TextStyle(fontSize: 15),
          enabled: enabled,
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController getControllerForField(String field) {
    switch (field) {
      case 'Name': return nameController;
      case 'Address': return addressController;
      case 'City': return cityController;
      case 'State': return stateController;
      case 'Pin Code': return pinCodeController;
      case 'GST Number': return gstNumberController;
      default: return nameController;
    }
  }

  Widget _buildActiveSubscription() {
    String plan = profileData['subscription'] != null && profileData['subscription']['plan'] != null
        ? profileData['subscription']['plan']
        : 'No Plan';

    Map<String, Map<String, dynamic>> subscriptionDetails = {
      'freebie': {
        'planName': 'Freebie',
        'price': 0,
        'description': 'Ideal for individuals who need quick access to basic features.',
        'activeFeaturesCount': 2,
      },
      'professional': {
        'planName': 'Professional',
        'price': 25,
        'description': 'Ideal for individuals who need advanced features and tools for client work.',
        'activeFeaturesCount': 6,
      },
      'enterprise': {
        'planName': 'Enterprise',
        'price': 100,
        'description': 'Ideal for businesses who need personalized services and security for large teams.',
        'activeFeaturesCount': 8,
      },
    };

    String Splan = '';
    int price = 0;
    String description = '';
    int activeFeaturesCount = 0;

    if (subscriptionDetails.containsKey(plan)) {
      var planDetails = subscriptionDetails[plan];
      Splan = planDetails!['planName'];
      price = planDetails['price'];
      description = planDetails['description'];
      activeFeaturesCount = planDetails['activeFeaturesCount'];
    }

    bool isNoPlan = plan == 'No Plan';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Active Subscription",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 23,
              color: subscriptionColor,
            ),
          ),
          const SizedBox(height: 26),
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isNoPlan ? "No Plan" : Splan,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: subscriptionColor,
                        ),
                      ),GestureDetector(
                        onTap: () {
                          // Navigate to SubscribePage and pass the accessToken
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscribePage(
                                accessToken: widget.accessToken, // Pass the access token here
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isNoPlan ? 'Subscribe' : 'Subscribed',
                            style: TextStyle(
                              fontSize: 14,
                              color: subscriptionColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isNoPlan) ...[
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: subscriptionColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.w700,
                            color: subscriptionColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '/ Month',
                          style: TextStyle(
                            fontSize: 16,
                            color: subscriptionColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subscriptionColor,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Active Subscription',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeature('20,000+ of PNG & SVG graphics', true),
                        SizedBox(height: 10),
                        _buildFeature('Access to 100 million stock images', true),
                        SizedBox(height: 10),
                        _buildFeature('Upload custom icons and fonts', activeFeaturesCount > 2),
                        SizedBox(height: 10),
                        _buildFeature('Unlimited Sharing', activeFeaturesCount > 3),
                        SizedBox(height: 10),
                        _buildFeature('Upload graphics & video in up to 4k', activeFeaturesCount > 4),
                        SizedBox(height: 10),
                        _buildFeature('Unlimited Projects', activeFeaturesCount > 5),
                        SizedBox(height: 10),
                        _buildFeature('Instant Access to our design system', activeFeaturesCount > 6),
                        SizedBox(height: 10),
                        _buildFeature('Create teams to collaborate on designs', activeFeaturesCount > 7),
                        SizedBox(height: 10),
                      ],
                    ),
                  ] else ...[
                    // Add other child widgets for "No Plan" case if needed
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String feature, bool isCheck) {
    return Row(
      children: [
        Icon(
          isCheck ? Icons.check_circle : Icons.cancel,
          size: 30,
          color: subscriptionColor,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            feature,
            style: TextStyle(
              fontSize: 16,
              color: subscriptionColor,
            ),
          ),
        ),
      ],
    );
  }
  Future<void> updateProfile() async {
    // Collect data from controllers
    final Map<String, String> data = {
      'name': nameController.text.isNotEmpty ? nameController.text : '',
      'city': cityController.text.isNotEmpty ? cityController.text : '',
      'state': stateController.text.isNotEmpty ? stateController.text : '',
      'pin_code': pinCodeController.text.isNotEmpty ? pinCodeController.text : '',
      'gst_number': gstNumberController.text.isNotEmpty ? gstNumberController.text : '',
    };

    // Call the updateProfile method from AuthProvider
    await Provider.of<AuthProvider>(context, listen: false)
        .updateProfile(widget.accessToken, data);

    setState(() {
      isEditing = false;
    });
  }

  // Create a row for Edit Profile and Active Subscription buttons
  Widget _buildButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Edit Profile Button widget
        ElevatedButton(
          onPressed: () async {
            // Call updateProfile when the user clicks "Save Changes"
            await updateProfile();
            setState(() {
              showEditProfileIcon = true;  // Show the profile edit icon again
              isEditing = false;  // Disable the editing mode
              showSubscription = true;  // Hide active subscription section
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          ),
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 5),
        // View Active Subscription Button widget with text color and border
        ElevatedButton(
          onPressed: () {
            setState(() {
              showSubscription = true; // Show active subscription section again
              isEditing = false;
              showEditProfileIcon = true;// Disable the editing mode
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: textColor),  // Border color is the same as text color
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          ),
          child: Text(
            "View Active Subscription",
            style: TextStyle(
              color: textColor,  // Text color is the same as the text color
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

}