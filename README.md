	Company.xml data/gui/dialogs/
	FG_Pax_init.nas data/Nasal/
	Company.nas data/FG_Pax/

~~Company.nas is used for easy refactoring and code writing (syntax highlighting), and code is transfered to Company.xml~~

TODO

v0.0.2
- Estimated income Dynamic
- ~~Capital Text Dynamic~~
- ~~Current departure Dynamic~~ 
- ~~Current destination Dynamic~~
- ~~ETA Dynamic~~
- ~~Distance left Dynamic~~
- ~~Time in air Dynamic~~
- ~~Deactivate **Start New Route** button when route started~~
- ~~Deactivate **Cancel Route** button when no route started~~
- ~~Activate **Start New Route** button when route finished~~
- ~~Activate **Cancel Route** button when route started~~
- ~~Add property **/fg-pax/money**~~
- ~~Add property **/fg-pax/route-done**~~
- ~~Add property **/fg-pax/route-started**~~
- ~~Add property **/fg-pax/eta**~~
- ~~Migrate the variables to properties (see above)~~
- Add property **/fg-pax/estimated-income**

v0.0.3
- Income calculation based on route distance (not distance flown or time flown)