Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

$packages_common = [
  'subversion',
  'git',
  'mercurial',
  'cvs',
  'curl',
  'unzip',
  'quilt',
  'patch',
  'gawk',
  'flex',
  'gettext',
]

case $operatingsystem {
  ubuntu : {
    $packages = [
      'build-essential',
#      'g++',
      'ncurses-term',
      'zlib1g-dev',
      'openssh-server',
      'libssl-dev',
      'minicom',
      'picocom',
      'tftp',
      'tftpd',
      'libncurses5',
      'libncurses5-dev',
      'git-doc',
      'git-gui',
      'libxml-parser-perl',
    ]

    exec { "apt-update":
      command => "/usr/bin/apt-get update"
    }
    Exec["apt-update"] -> Package <| |>
  }
}


package { $packages_common:
  ensure => installed,
}

package { $packages:
  ensure => installed,
}


include carambola2

