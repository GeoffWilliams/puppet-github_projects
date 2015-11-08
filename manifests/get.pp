define github_projects::get(
  $github_user,
  $local_user,
  $base_dir    = $title,
  $script_dir  = $github_projects::script_dir,
  $script_file = $github_projects::script_file,
  $nopull      = $github_projects::nopull,
  $timeout     = $github_projects::timeout,
  $token       = false,
  $password    = false,
) {

  $script = "${script_dir}/${script_file}"
  $_nopull = $nopull ? {
    true  => "--nopull",
    false => "",
  }

  if $token {
    $auth = "--token ${token}"
  } elsif $password {
    $auth = "--password ${password}"
  } else {
    fail("${module_name}::get { ${title}:} requires one of token or password to be set")
  }

  # Run this every puppet run to fetch any new projects
  exec { "github_projects__get_${title}":
    command => "${script} -u ${github_user} ${_nopull} --dest ${base_dir} ${auth}",
    user    => $local_user,
    path    => [
        "/bin",
        "/usr/bin",
    ],
    timeout => $timeout,
    require => Package["pygithub"],
  }
}
