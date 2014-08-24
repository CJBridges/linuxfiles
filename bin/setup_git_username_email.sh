setup_git_username_email() {
  git config --global --get user.name > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    read -p "Please enter your full name for git (e.g. \"John Doe\"): " GIT_USER
    git config --global --replace-all user.name "$GIT_USER"
  fi
  git config --global --get user.email > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    read -p "Please enter your email for git (e.g. \"jdoe@example.com\"): " GIT_EMAIL
    git config --global --replace-all user.email "$GIT_EMAIL"
  fi
}

setup_git_username_email
