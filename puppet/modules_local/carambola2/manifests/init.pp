class carambola2 {

  $repository_url = 'https://github.com/8devices/carambola2'
  $build_dir = '/home/vagrant/carambola2'

  vcsrepo { "${build_dir}":
    ensure   => latest,
    provider => git,
    require  => [ Package['git'] ],
    source   => "${repository_url}",
    revision => 'master',
    owner    => 'vagrant',
    group    => 'vagrant',
  }

  file { 'aliases':
    path    => '/home/vagrant/.bash_aliases',
    ensure  => file,
    content => template("carambola2/aliases.erb"),
    owner   => 'vagrant',
    group   => 'vagrant',
  }
}

