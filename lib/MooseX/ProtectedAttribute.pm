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
