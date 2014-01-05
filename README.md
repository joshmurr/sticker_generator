### Sticker Generator

A program which takes a word as an input and then does the following:

1. Performs a Google image search for that word and chooses at random one of the first 8 images.
2. Picks a random font from my computer and makes an images with the given word in that font in the chosen colour.
3. Combines the found image and text image into one via a blend image treatment.
4. Places a frame around the image.
5. Uses a Floyd-Steinberg dithering algorithm over the entire thing.
6. Places the image onto a sticker sheet, and when the sheet is full, prints the page (by saving it in a folder which has a "Send to Print" action applied to it using Apple Automator).

Still a work in progress, and in need of better documentation.

All stickers made so far can be seen on the [Sticker Wall](http://stickerwall.tumblr.com/).
