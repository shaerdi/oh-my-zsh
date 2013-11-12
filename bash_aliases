alias ..="cd .."
alias ...="cd ../.."
alias log="tail -f log*"
alias yade="~/yade/build/bin/yade-2013-04-23.git-e9dbeff"
alias gvim="gvim &> /dev/null"
alias zotero="/home/simon/Documents/Literatur/ZoteroProgram/run-zotero.sh"


# gdir, cdir and sdir functions
function gdir {
  typeset -i z
  if [ $# -eq 0 ]; then 
     num=0
     z=0
     until [ $z -eq 9 ]; do
       [[ -e  ~/.sdir/.sdir$z ]] && echo $z " " $(cat ~/.sdir/.sdir$z)
       z=z+1
     done
  else
     num=$@
     cd `cat $HOME/.sdir/.sdir$num`
  fi
}

function cdir {
  typeset -i z
  if [ $# -eq 0 ]; then 
     num=0
     z=0
     until [ $z -eq 9 ]; do
       [[ -e  ~/.sdir/.sdir$z ]] && echo $z " " $(cat ~/.sdir/.sdir$z)
       z=z+1
     done
  else
     num=$2
     cp -rp $1 `cat $HOME/.sdir/.sdir$num`
  fi
}

function sdir {
  if [ $# -eq 0 ]; then 
     num=0
  else
     num=$@
  fi
  [[ ! -e ~/.sdir ]] && mkdir ~/.sdir
  echo $PWD > ~/.sdir/.sdir$num
}

function runall {
  for i in `ls */ -d`;
  do
      cd $i;
      $@;
      cd ..;
  done
}

alias plotAvValue="python ~/scripts/plotOFaverageValue.py"
