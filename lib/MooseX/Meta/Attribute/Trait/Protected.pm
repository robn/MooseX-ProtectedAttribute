package MooseX::Meta::Attribute::Trait::Protected;

use Moose::Role;

has "protection" => (
    is      => "rw",
    isa     => "Str",
    default => "private",
);

1;
