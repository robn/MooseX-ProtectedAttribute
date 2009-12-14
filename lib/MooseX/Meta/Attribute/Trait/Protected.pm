package MooseX::Meta::Attribute::Trait::Protected;

use Moose::Role;

has "protection" => (
    is      => "rw",
    isa     => "Str",
    default => "private",
);

no Moose::Role;

package # hide from PAUSE
    Moose::Meta::Attribute::Custom::Trait::Protected;

sub register_implementation { "MooseX::Meta::Attribute::Trait::Protected" }

1;
