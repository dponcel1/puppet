class dapb::app {
  file { "/var/www/rhel7-test/index.html":
    ensure => file,
    mode   => 755,
    owner  => root,
    group  => root,
    source => "puppet:///modules/dapb/index.html",
    require => Class["dapb::httpd"],
  }
}
