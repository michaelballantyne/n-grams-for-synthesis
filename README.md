# n-grams-for-synthesis, attempt #3 (at least!)

n-gram probabilities based on Scheme/Racket code, for directing search of the relational Scheme interpreter, and a prototype example relational interpreter with a search informed by these probabilities.

The ideas explored in this repo are inspired by conversations and hacking sessions that included: Rob Zinkov, Michael Ballantyne, Will Byrd, Greg Rosenblatt, Evan Donahue, Ramana Kumar, Nehal Patel, attendees of the Advanced miniKanren Hangout series, and members of the broader miniKanren community.  Early hacking to extract poatterns from Clojure code was done by Micahel Ballantyne and Will Byrd, with critical guidance from Rob Zinkov (see https://github.com/webyrd/rnn-clojure).  Will hacked up a crude, somewhat broken version of the system in the `old_code/original_version` directory.  This was improved by "mob programming" during miniKanren advanced hangouts #6 and #7 (see https://github.com/webyrd/miniKanren-hangout-summaries and https://github.com/webyrd/miniKanren-hangout-summaries/tree/master/code/advanced-hangouts)--the improved code can be found in `old_code/advanced_hangout_7_version`.

This latest attempt at n-gram-based guided search was inspired by Rob Zinkov hosting Will Byrd at University of Oxford in January of 02018.  Rob has been hacking on getting a larger corpus of trainign programs, while Will has been working on how to better integrate the resulting probabilities into the relational interpreters.

Many thanks to everyone who has helped improve the ideas and code!