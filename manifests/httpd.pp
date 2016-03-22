class dapb::httpd {
  package { 'httpd':
    ensure => installed,
  }
  service { 'httpd':
    ensure => running,
    enable => true,
    require => Package["httpd"],
  }
  file {'/etc/httpd/conf.d/rhel7-test.conf':
  notify => Service["httpd"],
    ensure => file,
    require => Package["httpd"],
    content => template("dapb/rhel7-test.conf.erb"),
  }
  file { "/var/www/rhel7-test":
    ensure => "directory",
  }
  if $operatingsystemmajrelease <= 6 {
    exec { 'iptables':
      command => "iptables -I INPUT 1 -p tcp -m multiport --ports ${httpd_port} -m comment --comment 'Custom HTTP Web Host' -j ACCEPT && iptables-save > /etc/sysconfig/iptables",
      path => "/sbin",
      refreshonly => true,
      subscribe => Package['httpd'],
    }
    service { 'iptables':
      ensure => running,
      enable => true,
      hasrestart => true,
      subscribe => Exec['iptables'],
    }
  }
  elsif $operatingsystemmajrelease == 7 {
    exec { 'firewall-cmd':
      command => "firewall-cmd --zone=public --add-port=${httpd_port}/tcp --permanent",
      path => "/usr/bin/",
      refreshonly => true,
      subscribe => Package['httpd'],
    }
    service { 'firewalld':
      ensure => running,
      enable => true,
      hasrestart => true,
      subscribe => Exec['firewall-cmd'],
    }
exec { 'semanage-port':
    command => "semanage port -a -t http_port_t -p tcp ${httpd_port}",
    path => "/usr/sbin",
    require => Package['policycoreutils-python'],
    before => Service ['httpd'],
    subscribe => Package['httpd'],
    refreshonly => true,
  }
  package { 'policycoreutils-python':
    ensure => installed,
  }
}
}
