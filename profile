source /opt/boxen/env.sh

# (l)ong, (a)ll, (p)ath marked, (h)uman numbers, (t)ime sorted, (r)everse sort
alias ls='ls -laphtr'

# A sorta short version of tree which only shows 2 levels of folders
alias bush='tree -d -L 2 --dirsfirst'
alias tree='tree --dirsfirst'

# Removes cached python files
alias clean='find . -name *.pyc -delete && find . -type d -name __pycache__ -delete'

# Run coverage.  If no errors, build html report and open in default browser.
# The omit option removes third party libraries from the report.
alias cover='coverage run --omit=/opt/boxen/pyenv* -m unittest discover && coverage html && open htmlcov/index.html'

# (\t)ime (\w)orking directory (\n)ewline (\u)ser@(\h)ost
export PS1="\t \w\n\u@\h: "

#Combines mkdir and cd commands.
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
