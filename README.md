# Yelp
This is a Yelp Search app that uses the Yelp Search API.

Submitted by: Namrata Mehta

Time spent: 14 hours spent in total

User Stories
The following user stories must be completed:

Search results page
* [+] Table rows should be dynamic height according to the content height.
* [+] Custom cells should have the proper Auto Layout constraints.
* [+] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
    Hint: This is just a UISearchBar that is set as the navigationItem.titleView
* [+] Optional: Infinite scroll for restaurant results
* [+] Optional: Implement map view of restaurant results [Implemeted this in the detail view controller page. When you clieck a restrauant name then restuarant details with the location on map is shown.]
        

Filter page. Unfortunately, not all the filters in the real Yelp App, are supported in the Yelp API.
* [+] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
* [+] The filters table should be organized into sections as in the mock.
* [+] You can use the default UISwitch for on/off states. 
* [ ] Optional: implement a custom switch
* [+] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
* [+] Optional: Distance filter should expand as in the real Yelp app.
* [ ] Optional: Categories should show a subset of the full list with a "See All" row to expand.
    A formatted list of categories available in the Public API can be found here.
* [+] Optional: Implement the restaurant detail page.


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/Nams2/Yelp/blob/master/YelpGIF.gif' title='Flicks Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).


## License

    Copyright [2017] [Namrata Mehta]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


