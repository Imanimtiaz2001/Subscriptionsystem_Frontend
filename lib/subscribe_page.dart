import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'profile_page.dart';
import 'package:flutter/material.dart';


class SubscribePage extends StatefulWidget {
  final String accessToken; // Declare a field for accessToken

  const SubscribePage({super.key, required this.accessToken});

  @override
  _SubscribePageState createState() => _SubscribePageState();

}

class _SubscribePageState extends State<SubscribePage> {
  bool isMonthly = true; // Track if it's monthly or yearly
  List<bool> isExpanded = List<bool>.filled(6, false);
  // Color and Style Definitions
  final textColor = const Color(0xFF333333);
  final primaryColor = const Color(0xFFC4C7FA);
  final subscriptionColor = const Color(0xFF444444);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333), // Set background color to textColor
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildPricingInfo(),
            _buildSubscriptionPlans(context),
            const SizedBox(height: 30),
            _buildFAQ(),
            const SizedBox(height: 30),
            _buildPricing(),
            _buildBrandLogos(),
            _buildFooter(),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: textColor),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: textColor),
                onSelected: (String value) {
                  if (value == 'profile') {
                    // Navigate to the ProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(accessToken: widget.accessToken),
                      ),
                    );
                  } else if (value == 'logout') {
                    // Show the logout confirmation dialog
                    _showLogoutDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: Text('Profile'),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
                offset: Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
              ),
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
// Pricing and subscription toggle
  Widget _buildPricingInfo() {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          "Start for free.\nPay as you grow",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bill Monthly",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  isMonthly = !isMonthly;
                });
              },

              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: isMonthly ? 5 : 30, // Move the switch based on the state
                      top: 2.5,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColor, // Switch color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            Text(
              "Yearly",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 200), // Set the margin from the left
          child: Image.asset(
            'assets/images/Arrow.PNG',
            width: 70,
            height: 60,
          ),
        ),// Arrow image
        Container(
          margin: const EdgeInsets.only(left: 250), // Set the margin from the left
          child: Text(
            "Save 25%",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Subscription Plans
  Widget _buildSubscriptionPlans(BuildContext context) {
    return Column(
      children: [
        _buildSubscriptionPlan(
          'Freebie',  // Updated to show "Freebie Plan"
          0,
          'Ideal for individuals who need quick access to basic features.',
          2,
          'freebie', // Plan type for Freebie
          context,
        ),
        _buildSubscriptionPlan(
          'Professional',
          25,
          'Ideal for individuals who need advanced features and tools for client work.',
          6,
          'professional', // Plan type for Professional
          context,
        ),
        _buildSubscriptionPlan(
          'Enterprise',
          100,
          'Ideal for businesses who need personalized services and security for large teams.',
          8,
          'enterprise', // Plan type for Enterprise
          context,
        ),
      ],
    );
  }

  // Build each subscription plan container
  Widget _buildSubscriptionPlan(String plan, int price, String description, int activeFeaturesCount, String planType, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),  // Set margin for containers
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),  // Added left and right padding of 20
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: subscriptionColor,
                        ),
                      ),
                    ],
                  ),
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
                    onPressed: () => _subscribeToPlan(context, planType), // Subscribe function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subscriptionColor,
                      padding: EdgeInsets.symmetric(horizontal: 95, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Subscribe',
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
                    ],
                  ),
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

  // FAQ Section
  Widget _buildFAQ() {
    return Column(
      children: [
        Text(
          "Frequently Asked Questions",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        for (int i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded[i] = !isExpanded[i];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isExpanded[i] ? const Color(0xFFB6EEBD) : textColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isExpanded[i] ? Color(0xFFB6EEBD) : Colors.white,  // Border color
                    width: 1,  // Border width
                  ),
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
                    // Horizontal Layout: Number + Question + Arrow
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: isExpanded[i] ? textColor : Colors.white,  // Border color
                              width: 1,  // Border width
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: isExpanded[i] ? textColor : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Frequently ask question goes in here',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: isExpanded[i] ? textColor : Colors.white,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded[i] ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: isExpanded[i] ? textColor : Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                    // Line separating question from answer when expanded
                    if (isExpanded[i]) ...[
                      SizedBox(height: 10),
                      Container(
                        width: 250, // Adjust the width as needed
                        margin: const EdgeInsets.only(left: 42),
                        child: Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '[answer here] lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        SizedBox(height: 60),
        Text(
          "Have more questions?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Contact Us here so we can help",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPricing()
  {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Truly Flexible Pricing Section
          Padding(
            padding: EdgeInsets.only(bottom: 20.0,top:40.0),
            child: Text(
              "Truly flexible pricing",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 33.5,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Text(
            "Unbeatable pricing and flexibility for the features you need.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          SizedBox(height: 40),

          // Sign Up Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
            children: [
              // Image 1 (replace 'assets/images/1.PNG' with your actual image path)
              Image.asset('assets/images/1.PNG', width: 60, height: 60),
              SizedBox(height: 30),
              // Heading with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'Sign up for free',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              // Description with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'When you can succeed free from the start. You\'ll have growing flexibility when accumulating for longer periods of time.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          Divider(
            color: Color(0xFF999999),
            thickness: 1,
          ),
          SizedBox(height: 30),
          // Add your team members Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
            children: [
              // Image 1 (replace 'assets/images/1.PNG' with your actual image path)
              Image.asset('assets/images/2.PNG', width: 60, height: 60),
              SizedBox(height: 30),
              // Heading with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'Add your team members',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              // Description with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          Divider(
            color: Color(0xFF999999),
            thickness: 1,
          ),
          SizedBox(height: 30),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
            children: [
              // Image 1 (replace 'assets/images/1.PNG' with your actual image path)
              Image.asset('assets/images/3.PNG', width: 60, height: 60),
              SizedBox(height: 30),
              // Heading with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'Add and manage tasks!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              // Description with left and right padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0), // Left and right margin
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),

          // Seamless integration across your tech-stack Section
          Row(
            children: [
              Text(
                'Seamless integration \nacross your tech-stack!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            "Connect TaskFlow to any of your existing tools with 2 clicks.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  // Brand Logos Section (Reusable image container)
  Widget _buildBrandLogos() {
    return Container(
      color: Colors.white,
      child: Column(

        children: [
          Image.asset(
            'assets/images/Group.PNG',
            width: double.infinity,// Adjust height as needed
            fit: BoxFit.cover,  // Ensure it covers the full width without distortion
          ),
          SizedBox(height: 40),

          // Explore Integrations button
          Center(
            child: ElevatedButton(
              onPressed: () {}, // Subscribe function
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'Explore Integerations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
          // Black Square with Text and Button
          SizedBox(height: 80),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 30),
            color: Colors.black, // Background color of the square
            child: Column(
              children: [
                SizedBox(height: 20), // Padding from top

                // Text inside the square
                Text(
                  'Ready to organize your remote work?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color inside the square
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15), // Space between the heading and subheading

                // Subheading text inside the square
                Text(
                  'Try the best project management \n tool in the industry, today!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color inside the square
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20), // Space between the text and button

                // Get Started button
                ElevatedButton(
                  onPressed: () {}, // Get started function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: textColor, // Button text color
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Padding from the bottom of the square
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  // Footer Widget
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: primaryColor, // Footer background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Logo section
          Row(
            children: [
              Image.asset(
                'assets/images/logo.PNG', // Same logo as in the header
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Text(
                "LOGO", // This can be replaced with your company name
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Text(
            "Uifry gives you the blocks and components you need to create a truly professional website.",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          // Social Media Icons
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/instagram.PNG', // Path to your Facebook icon image
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/images/flickr.PNG', // Path to your LinkedIn icon image
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/images/pinterest.PNG', // Path to your Twitter icon image
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/images/twitter.PNG', // Path to your Twitter icon image
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Vertically aligned Company, Help, and Resources Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFooterSection("Company" , ["About", "Features", "Works", "Career"]),
              const SizedBox(height: 20), // Space between sections
              _buildFooterSection("Help", ["Customer Support", "Delivery Details", "Terms & Conditions", "Privacy Policy"]),
              const SizedBox(height: 20), // Space between sections
              _buildFooterSection("Resources", ["Free eBooks", "Development Tutorial", "How to - Blog", "YouTube Playlist"]),
            ],
          ),
          SizedBox(height: 30),
          Divider(
              color: textColor,
              thickness: 1,
            ),
          const SizedBox(height: 15),

          // Copyright Section
          Text(
            "© Copyright 2022, All Rights Reserved",
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

// Helper function to build footer sections like Company, Help, and Resources
  Widget _buildFooterSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
        for (String item in items)
          Text(
            item,
            style: TextStyle(
              fontSize: 17,
              color: textColor,
            ),
          ),
      ],
    );
  }
  // Updated Subscribe button to call subscribe function from AuthProvider
  void _subscribeToPlan(BuildContext context, String planType) {
    Provider.of<AuthProvider>(context, listen: false)
        .subscribeToPlan(context, planType, widget.accessToken);
  }

  // Helper function to display dialog box
  Future<void> _showDialogBox(BuildContext context, String message) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
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
}