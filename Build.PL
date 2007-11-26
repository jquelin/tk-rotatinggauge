#!perl
#
# This file is part of Tk::RotatingGauge.
# Copyright (c) 2007 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new (
    module_name         => 'Tk::RotatingGauge',
    dist_author         => 'Jerome Quelin <jquelin@cpan.org>',
    license             => 'perl',
    dist_version_from   => 'lib/Tk/RotatingGauge.pm',
    add_to_cleanup => [
        'Tk-RotatingGauge-*', 'MANIFEST.bak',
        map { ( '*/' x $_ ) . '*~' } 0..4 ],
    script_files   => [ ],
    build_requires => {
        'Test::More' => 0,
        'Tk'         => 0,
        'perl'       => '5.008',
    },
    requires       => {
        'Tk'   => 0,
        'perl' => '5.008',
    },
    recommends     => {
        'Test::Pod'           => 0,
        'Test::Pod::Coverage' => 0,
    },
);

$builder->create_build_script();
