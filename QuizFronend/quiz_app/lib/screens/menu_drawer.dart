import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.redAccent),
              title: Text("About Us"),
              onTap: () {
                Navigator.pop(context); 
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("About Us"),
                    content: Text(
                      "This is a Buddhist Quiz App created to enhance knowledge about Buddhism by Dhamma Digital \nCreated by: Kashyapa Thero ",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
            leading: Icon(Icons.link, color: Colors.redAccent),
            title: Text("Official Page"),
            onTap: () {
              Navigator.pop(context);
              _launchURL('https://dhamma.digital/'); // ✅ Direct link
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.redAccent),
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.pop(context);
              _launchURL('https://dhamma.digital/privacy-policy/'); // ✅ Direct link
            },
          ),
            ListTile(
              leading: Icon(Icons.description, color: Colors.redAccent),
              title: Text("Terms & Conditions"),
              onTap: () {
              Navigator.pop(context);
              _launchURL('https://dhamma.digital/terms-and-conditions/'); // ✅ Direct link
              },
            ),
          ],
        ),
      ),
    );
  }
}
