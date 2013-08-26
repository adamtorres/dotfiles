source /opt/boxen/env.sh

# (l)ong, (a)ll, (p)ath marked, (h)uman numbers, (t)ime sorted, (r)everse sort
alias ls='ls -laphtr'

# Removes cached python files
alias clean='find . -name *.pyc -delete'

# (\t)ime (\w)orking directory (\n)ewline (\u)ser@(\h)ost
export PS1="\t \w\n\u@\h: "
