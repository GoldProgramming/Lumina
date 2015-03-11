## Lumina - Server, program, and client manager
### Programmed in Lua, HTML, and JavaScript using cqueues and Bootstrap[*](#post-notes)

---

### Purpose

Lumina can be as easy as making a folder and a main.lua with the code ```print( "Hello World" )``` on them.
However, Lumina is meant to be a language based more upon management and running many things at once.
Included with the repository are some examples - self-written - that display how Lumina is efficient in performing multiple tasks at once.
Users can run an HTTP server, an IRC server, and a WebSocket server all managed by Lumina.
Below is a simplified explanation on how to use Lumina.

### Usage

Files in main directories with the following file names: ```main(.lua|(.srv|.cli))``` will be treated as 'main' program files.
These files, if detected - in order above -  will be loaded as the 'main program file' for Lumina.
Lumina will set up the API (```require( "lumina" )```) and the user will be able to start their code.
Documentation will be available not through the README, but in later posted docs.

### Credits

 - Programmed by AlissaSquared
 - Documented by AlissaSquared
 - Everything by AlissaSquared

### Post-notes

 * ### Lua
 > Lua is an embeddable language programmed in ANSI C which is used in lightweight server applications. [Website](http://lua.org/).
 * ### cqueues
 > cqueues (read: Conditional Queues) is a [coroutine](#coroutine)-based asyncio library for Lua, to help with servers and asynchronous execution. [Website](http://25thandclement.com/~william/projects/cqueues.html).
 * ### HTML & JavaScript
 > HTML and JavaScript are both used in the creation of web applications that can be loaded in programs such as Mozilla Firefox, Google Chrome, and (god forbid) Internet Explorer.
 * ### Bootstrap
 > Bootstrap is a combination of JavaScript and CSS3 files that allow for easier creation of themes, and is used in the client frontend to give the user a friendlier experience. [Website](http://getbootstrap.com).
 * ### Coroutine
 > Coroutines are forms of running code that can be yielded at any location and later be resumed. This is useful for larger-scale applications needing to perform multiple tasks at once. [Reference](http://www.lua.org/manual/5.2/manual.html#2.6).
