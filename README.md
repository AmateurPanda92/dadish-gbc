# 🥕 Dadish GBC

An unofficial fan port of [Dadish](https://www.thomaskyoung.com/dadish) (original game by [Thomas K. Young](https://www.thomaskyoung.com/)) for the Game Boy Color, written in C, and developed using the [GBDK-2020](https://gbdk-2020.github.io/) SDK.

## Development instructions

### Prerequisites

At present, the only platforms supported for development are x64 versions of Windows, as that’s what I (@andiemmadavieswilcox) use. It wouldn’t be hard to support others in future though, so file an issue to support other dev platforms if you’d like to contribute to the project yourself.

### Building

To build the game from source:

1. Start a PowerShell or Command Prompt instance at the root of the repo.
2. Change the working directory to the `/Scripts` subdirectory:
```ps
cd .\Scripts\
```
3. Run `Compile.bat` to build the ROM from source:
```ps
.\Compile.bat
```
4. The output binary, `Dadish.gbc`, will be generated in the `/Output` directory.

### Running

Once you’ve built the ROM from source, you can run it in an emulator:

1. Start a PowerShell or Command Prompt instance at the root of the repo.
2. Change the working directory to the `/Scripts` subdirectory:
```ps
cd .\Scripts\
```
3. Run `Run.bat` to open the compiled ROM in an emulator:
```ps
.\Run.bat
```
4. The default emulator for the project (mGBA) will open and the ROM will be loaded.

## Resources

* **Sprite sheets:** https://www.spriters-resource.com/mobile/dadish
* **mGBA command line usage:** https://manpages.ubuntu.com/manpages/bionic/man6/mgba.6.html
