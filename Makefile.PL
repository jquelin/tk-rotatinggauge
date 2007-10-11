#!perl
#
# This file is part of Tk::RotatingGauge.
# Copyright (c) 2007 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

require 5.8.0;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Tk::RotatingGauge',
    AUTHOR              => 'Jerome Quelin <jquelin@cpan.org>',
    VERSION_FROM        => 'lib/Tk/RotatingGauge.pm',
    ABSTRACT_FROM       => 'lib/Tk/RotatingGauge.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'      => 0,
        'Tk'              => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => [
                'Tk-RotatingGauge-*', 'MANIFEST.bak',
                map { ( '*/' x $_ ) . '*~' } 0..4
        ] },
);
