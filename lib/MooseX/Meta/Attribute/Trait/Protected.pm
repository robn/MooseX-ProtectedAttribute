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

    return $self->$orig(@_) if $_[0] ne "accessor";

    my $name = $self->name;
    my $class = $self->associated_class->name;
    my $protection = $self->protection;

    if (! grep { $protection eq $_ } qw(private protected public)) {
        confess "Unknown value '$protection' for option 'protection' on attribute '$name'";
    }

    return $self->$orig(@_) if $protection eq "public";

    my ($method, $code) = $self->$orig(@_);

    my $wrap = Class::MOP::Method::Wrapped->wrap($code);

    # private. the caller must be in the same class that the object is blessed into
    if ($protection eq "private") {
        $wrap->add_around_modifier(sub {
            my $orig = shift;
            my ($self) = @_;

            if (caller ne ref $self) {
                confess "Method '$method' in class '$class' is private";
            }

            goto $orig;
        });
    }

    # protected. the caller must be in the same class or one of of the
    # subclasses of that which the object is blessed into
    elsif ($protection eq "protected") {
        $wrap->add_around_modifier(sub {
            my $orig = shift;
            my ($self) = @_;

            if (!(caller eq ref $self || $self->isa(caller))) {
                confess "Method '$method' in class '$class' is protected";
            }

            goto $orig;
        });
    }

    else {
        confess "Unknown protection type '$protection'. This is a bug in MooseX::ProtectedAttribute. Report it!";
    }

    return ($method, $wrap);
};

no Moose::Role;

package # hide from PAUSE
    Moose::Meta::Attribute::Custom::Trait::Protected;

sub register_implementation { "MooseX::Meta::Attribute::Trait::Protected" }

1;
