node 'lamp' {
  include lamp
}

node default { notify { 'this node did not match any of the listed definitions': } }