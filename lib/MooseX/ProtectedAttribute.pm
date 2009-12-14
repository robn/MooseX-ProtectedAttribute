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
}

sub has_private {
}

1;
