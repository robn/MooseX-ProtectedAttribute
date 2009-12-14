package MooseX::Meta::Attribute::Trait::Protected;

use Moose::Role;

has "protection" => (
    is      => "rw",
    isa     => "Str",
    default => "private",
);

around "_process_accessors" => sub {
    my $orig = shift;
    my $self = shift;

    print "PA: _process_accessors\n";

    print "    orig: $orig\n";
    print "    self: $self\n";

    if (@_) {
        print "    args:\n";
        print "        $_\n" for map { defined $_ ? $_ : "[undef]" } @_;
    }

    my ($name, $method) = $self->$orig(@_);

    my $wrap = Class::MOP::Method::Wrapped->wrap($method);
    $wrap->add_around_modifier(sub {
        my $orig = shift;

        print ">>> I'm around $name\n";

        goto $orig;
    });

    return ($name, $wrap);
};

no Moose::Role;

package # hide from PAUSE
    Moose::Meta::Attribute::Custom::Trait::Protected;

sub register_implementation { "MooseX::Meta::Attribute::Trait::Protected" }

1;
