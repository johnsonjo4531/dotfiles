---
name: todos
description: Helps an agent know how to use a TODOS.md file and how to do a todo in a TODOS.md file
---

If TODOs from TODOS.md are already checked do not do them again. When you complete a todo please immediately check it so work is not duplicated. If you see a TODO that is already done also check it off.

When asked to do todos from TODOS.md you can finish some of the todos instead of all of them. If you finish some please take all instructions in this file for those ones you complete. Check off the todos you have completed and leave alone the ones you have not. Some reasons you should finish only some TODOs would be if you are running out of context or if you need to prioritize more of your context towards a given todo. You should plan ahead to roll out TODOs in phases do this by first numbering the TODOs (instead of bullet points or an unordered list change them to numbers so they are an ordered list) then adding a phases section. The phases section should start with a 2nd level header with each phase as a 3rd level header. Each phase will list which tasks it is doing in unordered list saying using references to the todos (e.g. T1 for todo 1). Every TODO must be assigned a phase if you are doing phases. Each phase should be something you are focused on finishing within the context window. You should treat each phase as a unit of work to try and plan all at once and then execute on/implement together. Every phase header should have a checkbox that you check off immediately once you are done with the phase.

When doing a todo from TODOS.md after doing the task please prepend the todo as text as what was done in changelog style writing into a section equal to the current version number (as given in package.json) into a ./CHANGELOG.md file. If the section is not yet there prepend the version number so they are in order of lexicographical DESCENDING order of versions from top to bottom.

After completing tasks from TODOS.md please write into the CURRENT_COMMIT_MESSAGE.md file append a good commit message for the change into the file.
