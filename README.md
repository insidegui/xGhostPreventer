# xGhostPreventer

An Xcode plug-in designed to prevent accidental app distribution through an unsafe version of Xcode.

### Why shouldn't I distribute my apps using a patched Xcode?

If your version of Xcode is patched to allow code injection by 3rd parties, it can potentially modify your binaries to run malicious code on your user's machines without your knowledge.

[This has happened before](https://en.wikipedia.org/wiki/XcodeGhost) and may happen again.

### But why would I want to install this?

I know there are many valid reasons for people to patch their Xcode to run arbitrary plugins, but if you do (and you're a responsible person), you should at least not use your patched version of Xcode to distribute your apps, that's why you should always keep an original version of Xcode around 😉

### Technical info

**Tested only on macOS 10.12.2, Xcode 8.2.1**

Designed to be installed automatically by [MakeXcodeGr8Again](https://github.com/fpg1503/MakeXcodeGr8Again).
