package Configure::Step;

use strict;
use vars qw($description @args);
use Parrot::Configure::Step ':gen';

$description="Generating config.h...";

@args=();

sub runstep {
  genfile('config/gen/config_h/config_h.in', 'include/parrot/config.h',
          commentType => '/*',
          ignorePattern => 'PARROT_CONFIG_DATE');

  my $hh = "include/parrot/has_header.h";
  open(HH, ">$hh.tmp")
    or die "Can't open has_header.h: $!";

  print HH qq(
/*
 ** !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 **
 ** This file is generated automatically by Configure.pl
 */
);

  for(Configure::Data->keys()) {
    next unless /i_(\w+)/;
    if(Configure::Data->get($_)) {
      print HH "#define HAS_HEADER_\U$1 1\n"
    }
    else {
      print HH "#undef HAS_HEADER_\U$1\n";
    }
  }
  
  close HH;

  copy_if_diff("$hh.tmp", $hh);
}

1;
