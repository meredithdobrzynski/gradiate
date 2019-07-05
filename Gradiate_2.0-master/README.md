# Gradiate
## Google - Best Google API Integration - Winner

We challenge you to build an app that best incorporates one of Google’s many APIs. For instance, your app could include a Google Sign In, Google Calendar, Google Maps, and more!

https://www.cornellappdev.com/hack-challenge-fa18

## Tagline
Turn an image into a Gradient
## Description
The app allows you take a picture or upload a picture, and using Google API it extracts the 3 most dominant colors, and returns a gradient. Furthermore, it allows you to share your gradient(s) on Facebook, Messenger, iMessage, Email, etc...
## Requirement Fulfillment
### iOS
1. We use NSLayout Constraints for the buttons
2. We use a CollectionView to display the gradients that were saved
3. We use a Navigation Controller to display the gradient that was most recently created
4. We integrated Google Cloud Vision API, to extract the dominant colors
### Backend
1. SQLAlchemy is used to create a database for the gradients created by the app
2. The database allows for users to view all of the gradients, to delete any number of gradients at a time, and to add a gradient to the databse 
3. There is also a wrapper that uses Google Cloud Vision API in order to retrieve the top three dominant colors from an image 
4. The API is deployed using Google Cloud

### Screenshots
They will be attached:
https://www.icloud.com/photos/#0AgadzsO9mzqD0A4arVCXODAw

