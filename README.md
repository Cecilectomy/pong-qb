# PICPUZ #

Old QuickBASIC / QBasic Pong clone.

I originally wrote this in the early 2000's when I was first getting into programming. TI83 Basic and QuickBASIC were my entry into programming, and this was one of the first things I coded.

This was the largest codebase I had at the time and I have massively re-organized and cleaned up the code, and updated for QB64 compatibility. A lot has been restructured and optimized and a lot of superfluous code removed, but the core code and logic remains mostly original and retains the ability to compile / run using original hardware and QB45 software tools.

## How To Play ##

### Menus ###

- **Up Arrow** - Move cursor up
- **Down Arrow** - Move cursor down
- **Left Arrow** - Move cursor left (if able)
- **Right Arrow** - Move cursor right (if able)
- **Enter** - Select / Change Option
- **Esc** - Back / Quit

### Game ###

Bounce the ball off the paddle past the opponent paddle to score points. First player to reach the max score wins.

Left paddle is human player, right paddle is computer player.

- **Up Arrow** - Move paddle up
- **Down Arrow** - Move paddle down
- **Esc** - Back / Quit

## Building ##

### Using QB64PE

#### Setup ####

- Install QB64PE (https://www.qb64phoenix.com) or QB64 (https://qb64.com)
- Add the QB64PE or QB64 installation directory to the system PATH
  - Command must be on the PATH, no fallback installation locations will be searched

#### Compile ####

Run the included build script to compile
- Windows `bin\build-qb64.bat`
- Linux `./bin/build-qb64.sh`

### Using DOSBox ###

#### Setup ####

- Install DOSBox-x (https://dosbox-x.com) or DOSBox (https://www.dosbox.com)
- Add the DOSBox-x or DOSBox installation directory to the system PATH
  - On Windows, if a command is not found, scripts will search common fallback installation locations
    1. Looks for dosbox-x command
    2. Looks for dosbox-x fallback installation location
    3. Looks for dosbox command
    4. Looks for dosbox fallback installation location
  - On Linux, no fallback installation locations will be searched
    - Looks for dosbox-x command
    - Looks for dosbox command if dosbox-x command was not found
- Install QuickBASIC 4.5 (Must obtain software)
  - Windows
    - Place files at C:\DOS\qb45
  - Linux
    - Place files at ~/DOS/qb45

#### Compile ####

Run the included build script to compile
- Windows `bin\build-dosbox.bat`
- Linux `./bin/build.sh`

### Original Hardware / Software

If you are using original hardware / software and have QB available, you can open the source in QB and/or compile using BC and LINK manually.

- `BC /O /T PONG.BAS,BUILD\PONG.OBJ;`
- `BC /O /T INC\MULTIKEY\ASM.BAS,BUILD\MULTIKEY.OBJ;`
- `LINK BUILD\PONG.OBJ+BUILD\MULTIKEY.OBJ,BUILD\PONG.EXE;`