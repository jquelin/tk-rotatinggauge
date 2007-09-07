#!/usr/bin/perl
#
# This file is part of Tk::RotatingGauge
# Copyright (c) 2007 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#

use strict;
use warnings;

use FindBin qw[ $Bin ];
use lib "$Bin/../lib";

use Tk;
use Tk::RotatingGauge;

my ($w, $h)     = (200, 30);
my ($f, $t, $v) = (0, 10, 4);
my $val = 5;

my $mw = Tk::MainWindow->new;
$mw->Button(-command=>\&minus, -text=> '-')->pack(-side=>'left');
my $g = $mw->RotatingGauge(
    -width   => $w,
    -height  => $h,
    -from    => $f,
    -to      => $t,
    -visible => $v,
    -value   => $val,
)->pack(-side=>'left', -expand=>1, -fill=>'both');
$mw->Button(-command=>\&plus,  -text=> '+')->pack(-side=>'left');
my $policy = 'rotate';
$mw->Checkbutton(
    -text     => 'strict',
    -variable => \$policy,
    -onvalue  => 'strict',
    -offvalue => 'rotate',
    -command  => sub { $g->configure(-policy=>$policy); },
)->pack(-side=>'left');

MainLoop;
exit;

sub minus { $val-=0.1; $g->value($val); }
sub plus  { $val+=0.1; $g->value($val); }

