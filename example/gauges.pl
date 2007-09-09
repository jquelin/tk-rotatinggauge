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
my ($f, $t, $v) = (2, 7, 3);
my $val = 5;
my $mw = Tk::MainWindow->new;
my $fr;
my ($i, @g, @val, @pol);

#
$i = 0;
$fr = $mw->Frame->pack;
$g[$i] = $fr->RotatingGauge(
    -width   => $w, -height  => $h,
    -from    => $f, -to      => $t,
    -visible => $v, -value   => $val[$i]=$val,
)->pack(-side=>'left', -expand=>1, -fill=>'both');
$fr->Button(-command=>sub{minus(0)}, -text=> '-')->pack(-side=>'left');
$fr->Button(-command=>sub{plus(0)},  -text=> '+')->pack(-side=>'left');
$pol[$i] = 'rotate';
$fr->Checkbutton(
    -text     => 'strict',
    -variable => \$pol[$i],
    -onvalue  => 'strict',
    -offvalue => 'rotate',
    -command  => sub { $g[$i]->configure(-policy=>$pol[$i]); },
)->pack(-side=>'left');

#
$i = 1;
$fr = $mw->Frame->pack;
$g[$i] = $fr->RotatingGauge(
    -width   => $w, -height  => $h,
    -from    => $f, -to      => $t,
    -visible => $v, -value   => $val[$i]=$val,
    -labels => [ qw[ foo bar two three four five six ] ],
)->pack(-side=>'left', -expand=>1, -fill=>'both');
$fr->Button(-command=>sub{minus(1)}, -text=> '-')->pack(-side=>'left');
$fr->Button(-command=>sub{plus(1)},  -text=> '+')->pack(-side=>'left');
$pol[$i] = 'rotate';
$fr->Checkbutton(
    -text     => 'strict',
    -variable => \$pol[$i],
    -onvalue  => 'strict',
    -offvalue => 'rotate',
    -command  => sub { $g[$i]->configure(-policy=>$pol[$i]); },
)->pack(-side=>'left');

MainLoop;
exit;

sub minus { my ($i)=@_; $val[$i]-=0.1; $g[$i]->value($val[$i]); }
sub plus  { my ($i)=@_; $val[$i]+=0.1; $g[$i]->value($val[$i]); }

