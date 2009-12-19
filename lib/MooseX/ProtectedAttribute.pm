package MooseX::ProtectedAttribute;

use strict;
use warnings;

use Moose ();
use Moose::Exporter ();

use MooseX::Meta::Attribute::Trait::Protected;

our $VERSION = '0.01';

Moose::Exporter->setup_import_methods(
    with_caller => [qw(has_protected has_private)],
    also        => "Moose",
);

sub has_protected {
    my $caller = shift;
    my $name = shift;
    my %options = @_;
    $options{traits} ||= [];
    unshift @{$options{traits}}, 'Protected';
    $options{protection} ||= "protected";
    Class::MOP::Class->initialize($caller)->add_attribute($name, %options);
}

sub has_private {
    my $caller = shift;
    my $name = shift;
    my %options = @_;
    $options{traits} ||= [];
    unshift @{$options{traits}}, 'Protected';
    $options{protection} ||= "private";
    Class::MOP::Class->initialize($caller)->add_attribute($name, %options);
}

1;

__END__

=pod

=head1 NAME

MooseX::ProtectedAttribute - hide your attributes from prying eyes

=head1 SYNOPSIS

    use Moose;
    use MooseX::ProtectedAttribute;

    has_private "thing" => {
        is  => "rw",
        isa => "Str",
    };

    has_protected "whatever" => {
        is  => "ro",
        isa => "Int",
    };

=head1 DESCRIPTION

MooseX::ProtectedAttribute allows you to restrict access to attribute accessor
methods. It allows you to created "private" and "protected" attributes than
can only be accessed from within the class they were declared in (private) or
its subclasses (protected). These are much like similarly named mechanisms
from other languages.

Note that due to limitations in Perl, the attributes created with this module
are not truly off-limits. See L<"CAVEATS"> for details.

=head1 EXPORTS

=head2 has_private

=head2 has_protected

=head1 CAVEATS

=head1 FEEDBACK

If you find this module useful, please consider rating it on the CPAN Ratings
service at
L<http://cpanratings.perl.org/rate?distribution=MooseX-ProtectedAttribute>

Please report bugs via the CPAN Request Tracker at
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-ProtectedAttribute>

If you like (or hate) this module, please tell the author! Send mail to
E<lt>rob@cataclysm.cxE<gt>.

=head1 AUTHOR

Copyright 2009 Robert Norris E<lt>rob@cataclysm.cxE<gt>.

=head1 LICENSE

This module is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
