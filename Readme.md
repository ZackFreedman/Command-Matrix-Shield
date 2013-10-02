The Command Matrix Shield is an expansion board for the ChipKit Uno32 that features an 8x8 LED matrix. The Command Matrix is bidirectional - you can display stuff on it, and sense light hitting it, simultaneously! It's the world's tiniest and most adorable touchscreen!

Important: This shield and the sketches are designed for ChipKIT, specifically the Uno32. THE CODE WILL NOT COMPILE UNDER ARDUINO - JUST MPIDE TARGETING THE UNO32. 

EAGLE files are stored in the folder "Command Matrix Shield PCB".

A straightforward debug program is in the folder "Command Matrix Shield Test". Expected behavior is to send coordinates over hardware serial at 9600 baud when a strong green or blue point light is shone at one of the pixels.

The software and hardware contain a large number of oversights, hacks, cut corners, and plain wrong decisions. Nevertheless, this is known working. Somehow.

Created by Zack Freedman of Voidstar Lab.
@ZackFreedman
yourstruly at zackfreedman com
zackfreedman.com
voidstarlab.com

For more information, visit http://zackfreedman.com/projects/command-matrix-shield/.

The Command Matrix Shield is open hardware licensed under Creative Commons Noncommercial Attribution. More permissive licenses are available on request.