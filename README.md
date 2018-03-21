# MyRoutes

Login Credentials:
1. email: ryn2624@gmail.com
2. pwd: password123

# Install guide
To install the app without pain, I’d require your phone’s UDID. 
1. Launch showmyudid.com on SAFARI only.
2. Follow the instructions and Install the certificates(It’s safe).
3. Send the UDID back to me, I’ll send you an installable link.

You can also install via Xcode.
1. Open MyRoutes.xcworkspace
2. Connect your device via a cable.
3. Select your device from top-left of the status bar.
4. Hit the Run Button(the ‘play’ symbol) 

# Test Guide
To test all the user stories,
1. Login with incorrect credentials.
2. Login with the correct credentials.
3. Select any place from the given list. (If you’re in India, complete this step by selecting an Indian place first else go for US ones.)
    1. Click on Navigate button on the top right
        1. Click on the navigate button on the bottom left.
        2. Go back to the app.
        3. Drag map away from the current position.
        4. Click on the re-center button on the bottom-left.
        v.  Go back from top-left.
    2. Click on any of listed places.
         1.  Same procedure as above
4. Try above procedures for the places in country other than the one tested above.
5. Return back to Places/Home.
6. Tap sidebar button from top left.
7. Click on logout.

# Thought Process
Thought Process
The initial thought while developing the application was that it would be a fairly easily task.


# Login Screen

Since the application had a Login flow, my first reaction was to develop the login screen.
1. Firebase Auth and DB were setup in a new Firebase project.
2. The app was connected with Firebase using Cocoapods.
3. The UI for the screen was designed. I chose a dark theme over a light one because of personal
preferences. Still, to justify, consider this to be the night mode.
4. A fairly easy to read code was written and the Login screen was implemented


# Places Screen

After successful login, the user would be presented with a list of saved places.
To implement this, data had to be fetched from Firebase DB. I prefer using Cloud Functions rather than using the traditional way as mentioned in Firebase Docs. The UI was made and connected to the API response.


# Nearby Screen

This is the place where I wanted to be creative. I searched for a number of APIs that would work on a place’s coordinates. forecast.io's weather and Google’s Places API won the race. Documentation was read & desired response structure was formulated.
I wanted weather info to be prominent. Weather’s UI was designed accordingly with GIFs changing according to location’s weather.
Google’s Place API’s nearby feature was used. Corresponding tableView cells were designed and implemented.
Google’s Place API’s photo feature was used to extract image for each of the nearby place.


# Map Screen

OnClick, each cell will take user to the MapView with a marker placed on the destination. If a direct route is available, the most-efficient one will be plotted and time, distance for the journey would be displayed beautifully.
A navigate button will launch Google Maps and start navigation.
A re-center button will do its intended work.


# Log Out Button

This was the most tricky part. Logout button’s placement was an issue initially. It couldn't have been placed on any of the screens designed above for obvious reasons.
So a sidebar/hamburger-menu was implemented. To make sure that the menu doesn't look absolutely empty, user’s picture, email and name were added to it. The sidebar was added.

# Order of implementation
1. Login flow i.e firebase auth 
2. Cloud functions
3. Network Layer
4. Places Screen
5. Google Maps API
6. Route plotting for saved locations • MapView Screen
7. Google Places Nearby API
8. Google Places Photo API
9. Route plotting for nearby places
10. Weather API
11. Nearby Places Screen
12. Sidebar
13. Logout Btn
