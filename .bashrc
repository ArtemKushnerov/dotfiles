export REPOS=~/dev/streetshares
export PATH=$PATH:$REPOS/kubernetes/scripts
export PATH=$PATH:$HOME/bin >> ~/.bash_profile

alias cleanpyc="find . -name *.pyc -delete"
alias gitaliases="cat ~/.git_aliases"
alias pullkub="pushd $REPOS/kubernetes && git pull && popd"
alias pullcommon3="pushd $REPOS/common3 && git pull && popd"
alias lint="./docker/linter.sh"
#alias test="./docker/tester.sh"
# aliases for local dev
alias start_mysql="pushd $REPOS/docker/ && ./mysql.sh && popd"
alias launch_all="pushd $REPOS/docker/ && docker start mysql && docker start streetshares && docker-compose up -d && popd"
alias start_nginx="pushd $REPOS/docker/ && ./nginx.sh && popd && dl nginx"
alias sql="mysql -u root -h 127.0.0.1"
 
# general commands
alias l="ls -lhaG"
alias ll="ls -lhaG"
alias la="ls -la"
alias grep="grep --color=auto"
alias watch="watch --color "
source ~/.dotfiles/.git_aliases
function gpullall () {
    pushd $REPOS;
    # pull all repositories, 8 repositories at a time
    find . -maxdepth 1 -type d \( ! -name . \) -print | xargs -P 8 -I{} bash -c "cd {} && [ -d ".git" ] && git pull";
    popd;
}
# CAREFUL! Know how to use this! For every branch in your current repo, delete any branch that has been merged and not pushed to a remote branch
alias deletelocalmergedbranches='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
# CAREFUL! For every repo, delete any branch that has been merged and does not have a remote branch
alias globaldeletelocalmergedbranches='find $REPOS -type d -mindepth 1 -maxdepth 1 | xargs -I {} sh -c '\''echo {}; cd {}; if [[ -d .git ]]; then git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d; fi'\'''
 
 
# up 'n' folders
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
 
# shell aliases
alias reload="source ~/.bashrc"
alias edit="vim ~/.bashrc"
alias k="clear"
alias cdrepos="cd $REPOS" 
# docker-compose aliases
alias dc="docker-compose"
alias dce="docker-compose exec"
 
# docker aliases
alias dp="docker ps -a"
alias dl="docker logs"
alias da="docker attach"
alias de="docker exec -it"
deb() {
    docker exec -it $1 bash
}
alias dstart="docker start"
alias dstop="docker stop -t 1"
alias drestart="docker restart -t 1"
alias drm="docker rm"
alias dprune="docker system prune"
alias upper='pushd $REPOS/docker && ./upper.sh && popd'
alias downer='pushd $REPOS/docker && ./downer.sh && popd'
alias dtail='docker logs --tail 0 -f'
 
# k8s aliases
alias cc='kubectl config current-context'
alias uc="kubectl config use-context"
alias kc="kubectl"
alias kcgpods="kubectl get pods -o wide"
alias kcdpods="kubectl describe pods"
alias kcgdepls="kubectl get deployments -o wide"
alias kcddepls="kubectl describe deployments"
# list all images for pods running in the current context
alias kcimages='kubectl get pods -o jsonpath="{.items[*].spec.containers[*].image}" |tr -s "[[:space:]]" "\n" |sort |uniq -c'
alias generatek8stoken='kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '\''{print $1}'\'')'
alias deletepodsinerrorstate='kubectl get pods --field-selector=status.phase=Error | awk "{print \$1}" | xargs -I {} kubectl delete pods/{}'
alias vi="nvim" 
alias vim="nvim" 
alias j="jobs"
alias f="fg"
# Get and decode a secret
function kcgsecret() {
    declare -i result
    declare secret_key="${1}"
    declare secret
    secret=$(kubectl get secret "${secret_key}" -o json)
    result=${?}
    if [[ ${result} = 0 ]]; then
        echo "${secret}" | jq -r '.data | map_values(@base64d)'
    fi
}
# Check the Nginx Configuration on the ingress controller
function checknginx() {
    declare ingress_pod_name
    ingress_pod_name=$(kubectl get pods -n ingress-nginx -o json | jq -r '.items[].metadata.name')
    if [[ -n "${ingress_pod_name}" ]]; then
        kubectl exec -n ingress-nginx "${ingress_pod_name}"  cat /etc/nginx/nginx.conf
    else
        "Failed to get ingress pod name"
    fi
}
 
# reset docker containers and images
function dreset() {
    docker stop -t0 $(docker ps -aq);
    docker rm $(docker ps -aq);
    docker rmi -f $(docker images -q);
}
 
# docker stop and rm container
function dkill() {
    docker stop -t 1 "$1"
    docker rm "$1"
}
 
# start docs server
alias start_docs="cd $REPOS/docs/_gitbook/v1 && npm run dev"
 
# aws shortcuts
sql_prod () { pushd $REPOS/aws; command ./sql.sh "$@"; popd; }
sql_staging () { pushd $REPOS/aws; command ./sql.sh "$@" -s; popd; }
sql_demo () { pushd $REPOS/aws; command ./sql.sh "$@" -demo; popd; }
sql_qa () { pushd $REPOS/aws; command ./sql.sh "$@" -qa; popd; }
 
 
# A simple man's way to login to ecr
alias ecrlogin='$(aws ecr get-login --no-include-email --region us-east-1)'
 
# command prompt settings (reference: http://blog.taylormcgann.com/2012/06/13/customize-your-shell-command-prompt/)
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='$(parse_git_branch)[`date "+%H:%M:%S"`] \[\033[1;32m\] \w  \[\033[1;35m\]$ \[\033[1;37m\]'
 
## make aliases
# list all targets in a makefile (https://gist.github.com/pvdb/777954)
alias lmt='make -rpn | sed -n -e "/^$/ { n ; /^[^ .#][^ ]*:/p ; }" | egrep --color "^[^ ]*:"'

# bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion || {
    # if not found in /usr/local/etc, try the brew --prefix location
    [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && \
        . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
}

eval "$(pyenv init -)"

export WORKON_HOME=~/.venvs
source /Users/artsiom/.pyenv/versions/3.6.9/bin/virtualenvwrapper.sh
export PATH=/Users/artsiom/.pyenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/artsiom/dev/streetshares/kubernetes/scripts:/Users/artsiom/bin

alias generatek8stoken='kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '\''{print $1}'\'')'

  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion


eval "$(nodenv init -)"

export LD_SDK_KEY=sdk-61c36063-e958-4eb3-8bb8-d6b2ce41e360

alias pytest="DB_NAME=pytest_application pytest"
alias wn="workon"
export LC_ALL=en_US.UTF-8
# export COMPOSE_FILE=docker/docker-compose.yml
export K8S_LAB=arn:aws:eks:us-east-1:263735779401:cluster/lab

complete -o default -o nospace -F _virtualenvs wn
__git_complete gco _git_checkout
eval "$(direnv hook bash)"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_COMMAND='ag --nocolor --ignore node_modules --ignore *.pyc --ignore __pycache__ -g ""'
export NPM_TOKEN=193aa62e23948e6e84ab208792e9d0f755d23ade

#export LC_ALL=C
