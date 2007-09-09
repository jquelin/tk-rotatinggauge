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

use DateTime;
use Time::HiRes qw[ time ];
use Tk;
use Tk::RotatingGauge;

my $SECS = 1000;
my $MINS = 60 * $SECS;

my $width  = 1000;
my $height = 30;
my $now = DateTime->from_epoch( epoch => time, time_zone=>'local' );

my $mw = Tk::MainWindow->new;
my $c_secs = $mw->RotatingGauge(
    -width   => $width, -height  => $height,
    -value   => $now->fractional_second,
    -from    => 0,
    -to      => 60,
    -visible => 30,
)->pack(-side=>'top');
my $c_mins = $mw->RotatingGauge(
    -width   => $width, -height  => $height,
    -value   => $now->minute + $now->second/60,
    -from    => 0,
    -to      => 60,
    -visible => 30,
)->pack(-side=>'top');
my $c_hours = $mw->RotatingGauge(
    -width   => $width, -height  => $height,
    -value   => $now->hour + $now->minute/60,
    -from    => 0,
    -to      => 24,
    -visible => 12,
)->pack(-side=>'top');
my $c_wday = $mw->RotatingGauge(
    -width   => $width, -height  => $height,
    -value   => $now->day_of_week + $now->hour/24 + $now->minute/3600,
    -from    => 1,
    -to      => 7,
    -visible => 4,
    -labels  => [ qw[ foo Monday Tuesday Wednesday Thursday Friday Saturday Sunday ] ],
)->pack(-side=>'top');


$mw->repeat( 50,   \&update_secs );
$mw->repeat( 1 * $SECS, \&update_mins );
$mw->repeat( 1 * $MINS, \&update_rest );
MainLoop;
exit;

sub update_secs {
    my $dt = DateTime->from_epoch( epoch => time ); # need hires precision
    $c_secs->value( $dt->fractional_second );
}
sub update_mins {
    my $dt = DateTime->now;
    $c_mins->value( $dt->minute + $dt->second / 60 );
}
sub update_rest {
    my $dt = DateTime->from_epoch( epoch=>time, time_zone=>'local' );
    $c_hours->value( $dt->hour + $dt->minute / 60 );
    $c_wday ->value( $dt->day_of_week + $dt->hour / 24 + $dt->minute / 3600 );
}
