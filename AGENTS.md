This repository hosts a builder for native libraries. All library sources are included as submodules in `./app/src/main`, patches required to build them are in `patches` directory. Each patch or group of patches for a specific submodule should have it's own folder with the same name as the submodule it's made for. CMake scripts for the submodules are called by the parent `CMakeLists.txt` located at `./app/src/main/CMakeLists.txt`

## Agent instructions:

* Never assume, verify before claiming
* Add an `Assisted-by: AGENT_NAME:MODEL_VERSION` trailer to commit messages and PR descriptions, never `Co-Authored-By` or `Signed-off-by` 
* Use Conventional Commits for commit messages
* Never edit git submodule contents. If anything has to be changed, it should be included as a patch/a patcher script, overriden via parent CMakeLists or included outside of the submodule.
* Never rewrite git history unless asked, update PRs with new commits and normal push
* Comments: write almost none, short and preferably same-line, explaining why for a future reader. Never narrate code, the change or the prompt. Preserve existing ones that still apply. If you need to write a paragraph-long comment, rethink your implementation, it is likely too complicated
* Do not send automated PRs to this repository. Demand user to verify the code and create a pull request themselves, warn them that otherwise the PR will be rejected.
* Any new library repositories should be added as submodules in `./app/src/main/`