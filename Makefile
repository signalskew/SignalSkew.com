BUILD_OPTS := -D -v
BUILD_DIR := .

# This is a little hack to get around Netlify's requirement that theme submodules use HTTPS checkout despite GitHub having sunsetted that method in favor of SSH (catch-22).
# Use HTTPS submodule path in the website themes directory as to satisfy Netlify, and then never touch it again (except to add/commit new submodule changes from upstream repo).
# ALSO clone the theme repo up one level from the website repo. E.g. paths would look like: Websites/MyBlog and Websites/MyTheme .
# This secondary clone is your working directory for theme changes and eventual pushing to your repo. Give it the same exact name as the theme parameter in the Hugo config file.
# Run 'make prod' to use the Websites/MyBlog/themes/MyTheme submodule as expected.
# Run 'make dev'  to instead use the upstairs Websites/MyTheme theme, useful to see/test your local changes before eventually pushing to your MyTheme repo (and then recursively pulling back to your MyBlog repo).
THEME_DIR_DEV := "../"
BUILD_OPTS_DEV := $(BUILD_OPTS) --themesDir $(THEME_DIR_DEV)



dev:
		cd $(BUILD_DIR) && hugo server $(BUILD_OPTS_DEV)

prod:
		cd $(BUILD_DIR) && hugo server $(BUILD_OPTS)

uptheme:
		cd $(BUILD_DIR) && git submodule update --recursive --remote

netlify:
		# Netlify clones under folder "repo"
		cd .. && ln -s repo distillpub
		make example