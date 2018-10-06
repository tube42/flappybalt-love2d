flappybalt-Löve2d
=================

 .. image:: doc/flappy-love.png


This is my `löve2d <https://love2d.org/>`_ port of `FlappyBalt <https://github.com/AdamAtomic/Flappybalt>`_ by Adam Atomics originally written in AS3 and Flixel.
I did this port to learn more about the Lua and löve2d framework.


I have also done a `libgdx port <https://github.com/tube42/flappybalt-gdx>`_ of the same project. In both cases, I used a minimal framework (bare libgdx and bare löve2d) plus a minimal library to replace the missing functionality from Flixel. The challenge has been to get the port so far as it can actually be played with as little code as possible, specially in the library part.


All in all, this has been a very fun experiment. Specially since it have brought a mentality directly opposite to the over-enginnered things I see at work ;)


Instructions
-------------

If you are a lucky ubuntu/debian user, it can be simple as this:

1. make setup
2. make run

Some other interesting make targets are "make package" to build a .love package and "make check" to run the (meaningless?) lua linter...
