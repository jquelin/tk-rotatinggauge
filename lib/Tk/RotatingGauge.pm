#
# This file is part of Tk::RotatingGauge
# Copyright (c) 2007 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#

package Tk::RotatingGauge;

use warnings;
use strict;

use POSIX qw[ floor ];
use Tk;
use Tk::Canvas;

use base qw[ Tk::Derived Tk::Canvas ];
Construct Tk::Widget 'RotatingGauge';


our $VERSION   = '0.21';


#
# Populate - Tk internals
#
sub Populate {
    my( $self, $args ) = @_;

    # create the parent widget, specify our options.
    $self->SUPER::Populate( $args );
    $self->ConfigSpecs(
        -box       => [ 'PASSIVE', undef, undef, 'black'  ],
        -from      => [ 'PASSIVE', undef, undef, 0        ],
        -indicator => [ 'PASSIVE', undef, undef, 'red'    ],
        -labels    => [ 'PASSIVE', undef, undef, undef    ],
        -orient    => [ 'PASSIVE', undef, undef, 'horiz'  ],
        -policy    => [ 'PASSIVE', undef, undef, 'rotate' ],
        -to        => [ 'PASSIVE', undef, undef, 100      ],
        -visible   => [ 'PASSIVE', undef, undef, 20       ],
        -value     => [ 'METHOD',  undef, undef, undef    ],
    );

    # store the initial value for after initialization.
    my $val = exists $args->{-value} ? delete $args->{-value} : 50 ;
    $self->{Configure}{-value} = $val;

    # let's wait for canvas to be created before initializing the
    # various canvas items that will compose the gauge.
    $self->afterIdle( sub { $self->_draw_items } );
}


#
# $gauge->value( $val );
#
# Sets a new value to the gauge. Update the canvas accordingly.
#
sub value {
    my ($self, $value) = @_;

    my $is_strict = $self->{Configure}{-policy} eq 'strict';
    my $from   = $self->{Configure}{-from};
    my $to     = $self->{Configure}{-to};

    # check out-of-bounds.
    my $frac = $value - int($value);
    $value = $is_strict ? $from : $value % ($to-$from) + $frac
        if $value < $from;
    $value = $is_strict ? $to : $value % ($to-$from) + $frac
        if $value >= $to;

    # move the canvas items around.
    my $v = $self->{Configure}{-value};
    my $d = ($v - $value) * $self->{Configure}{-step};
    my @delta = $self->{Configure}{-is_horiz} ? ($d, 0) : (0, $d);
    $self->move( 'grid', @delta );
    $self->{Configure}{-value} = $value;
}


#
# $gauge->_draw_items;
#
# Initialization of the various items that will compose the gauge.
#
sub _draw_items {
    my ($self) = @_;

    # get & compute some values...
    my $w = $self->{Configure}{-width};
    my $h = $self->{Configure}{-height};
    my $is_horiz = ( 'vertical' !~ /$self->{Configure}{-orient}/ );
    $self->{Configure}{-is_horiz} = $is_horiz;

    my $labels  = $self->{Configure}{-labels};
    my $from    = $self->{Configure}{-from};
    my $to      = $self->{Configure}{-to};
    my $visible = $self->{Configure}{-visible};
    my $step    = ($is_horiz ? $w : $h) / $visible;

    $self->{Configure}{-step}  = $step;


    # create the central line showing the value.
    if ( $self->{Configure}{-indicator} ne 'none' ) {
        my @coords = $is_horiz ? ($w/2 , 0, $w/2 ,$h) : (0, $h/2, $w, $h/2);
        $self->createLine( @coords, -fill=>$self->{Configure}{-indicator}, -width=>2);
    }

    # create the top / bottom lines if needed.
    if ( $self->{Configure}{-box} ne 'none' ) {
        my @coords;
        @coords = $is_horiz ? (1, 1, $w, 1) : (1, 1, 1, $h); 
        $self->createLine( @coords, -fill=>$self->{Configure}{-box} );
        @coords = $is_horiz ? (1, $h, $w, $h) : ($w, 1, $w, $h); 
        $self->createLine( @coords, -fill=>$self->{Configure}{-box} );
    }

    # draw ticks $from .. $to.
    foreach my $i ( $from .. $to-1 ) {
        my @coords;
        my $x    = $i * $step;
        my $text = defined $labels ?  $labels->[$i] : $i;
        @coords = $is_horiz ? ($x, 0, $x, $h) : (0, $x, $w, $x);
        $self->createLine( @coords, -tags=>'grid' );
        @coords = $is_horiz ? ($x+$step/2, $h/2) : ($w/2, $x+$step/2);
        $self->createText( @coords, -text=>$text, -tags=>'grid' );
    }
    # draw $visible ticks before $from and after $to.
    foreach my $i ( 0 .. $visible ) {
        my @coords;
        # before $from
        my $x    = -($i+1-$from) * $step;
        my $text = defined $labels ? $labels->[$to-1-$i] : $to-1-$i;
        @coords = $is_horiz ? ($x, 0, $x, $h) : (0, $x, $w, $x);
        $self->createLine( @coords, -tags=>'grid' );
        @coords = $is_horiz ? ($x+$step/2, $h/2) : ($w/2, $x+$step/2);
        $self->createText( @coords, -text=>$text, -tags=>'grid' );
        # after $to
        $x    = ($to+$i) * $step;
        $text = defined $labels ? $labels->[$from+$i] : $from+$i;
        @coords = $is_horiz ? ($x, 0, $x, $h) : (0, $x, $w, $x);
        $self->createLine( @coords, -tags=>'grid' );
        @coords = $is_horiz ? ($x+$step/2, $h/2) : ($w/2, $x+$step/2);
        $self->createText( @coords, -text=>$text, -tags=>'grid' );
    }


    # move the gauge to its initial value.
    my $v = $self->{Configure}{-value};
    my $d = ($visible/2-$v) * $step;
    my @delta = $is_horiz ? ($d,0) : (0,$d);
    $self->move( 'grid', @delta );

}



1;
__END__

=head1 NAME

Tk::RotatingGauge - a rotating gauge for Tk



=head1 SYNOPSIS

    use Tk::RotatingGauge;

    my $g = $parent->RotatingGauge( @options );
    $g->value(10.5);



=head1 DESCRIPTION

This perl module provides a new Tk widget representing a gauge where the
current value always stays at the same place. Think about your old
mileage counters...



=head1 STANDARD OPTIONS

B<-background>



=head1 WIDGET OPTIONS

=over 4


=item B<-box>

Specifies the color of the lines boxing the gauge. If set to C<none>,
then no box will be drawn. Default to C<black>.


=item B<-from>

A real value corresponding to the minimum end of the gauge. Default to
0.


=item B<-height>

Specifies a desired window height that the widget should request
from its geometry manager.


=item B<-indicator>

Specifies the color of the central indicator. If set to C<none>, then no
central indicator will be drawn. Default to C<red>.


=item B<-policy>

Define the rotating policy: if set to C<rotate> (default), then
out of bounds values will be mod-ed to fit in the wanted scale. If set
to C<strict>, values can't go lower than C<-from> or higher than C<to>.


=item B<-top>

A real value corresponding to the maximum end of the gauge. Default to
100.


=item B<-value>

The initial value to be shown. Default to 50.


=item B<-visible>

The number of values to be displayed. Default to 20.


=item B<-width>

Specifies a desired window width that the widget should request
from its geometry manager.


=back



=head1 METHODS

=head2 $gauge->value($val)

Sets the value that the gauge should indicate.



=begin pod-coverage

This pod section is meant to fool the pod coverage test.

=head2 Populate

=end pod-coverage




=head1 BUGS

Please report any bugs or feature requests to C<< < bug-tk-rotatinggauge at
rt.cpan.org> >>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tk-RotatingGauge>.  I will be
notified, and then you'll automatically be notified of progress on your
bug as I make changes.



=head1 SEE ALSO

C<Tk::RotatingGauge> development takes place on
L<http://tk-rotatinggauge.googlecode.com> - feel free to join us.


You can also look for information on this module at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tk-RotatingGauge>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tk-RotatingGauge>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tk-RotatingGauge>

=back



=head1 AUTHOR

Jerome Quelin, C<< <jquelin at cpan.org> >>



=head1 COPYRIGHT & LICENSE

Copyright (c) 2007 Jerome Quelin, all rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

