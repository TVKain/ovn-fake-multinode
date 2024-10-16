central="ct-1-1"

chassises=("gw-1" "cp-1" "cp-2")

for chassis in ${chassises[@]}; do
    alias ovs-ofctl-${chassis}="docker exec ${chassis} ovs-ofctl"
    alias ovs-vsctl-${chassis}="docker exec ${chassis} ovs-vsctl"
done

alias ovn-nbctl="docker exec ${central} ovn-nbctl"
alias ovn-sbctl="docker exec ${central} ovn-sbctl"
