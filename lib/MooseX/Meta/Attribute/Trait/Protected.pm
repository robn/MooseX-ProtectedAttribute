package MooseX::Meta::Attribute::Trait::Protected;

use Moose::Role;
use Moose::Util qw(meta_attribute_alias);

use MooseX::Types::Moose qw(Str HashRef);
use MooseX::Types::Structured qw(Dict Optional);
use MooseX::Types -declare => [qw(ProtectionTable)];

my @types = qw(accessor reader writer predicate clearer);

has "protection" => (
    is      => "rw",
    isa     => ProtectionTable,
    default => sub {
        return { map { $_ => "private" } @types };
    },
    coerce  => 1,
);

subtype ProtectionTable,
    as Dict[
        accessor  => Optional[Str],
        reader    => Optional[Str],
        writer    => Optional[Str],
        predicate => Optional[Str],
        clearer   => Optional[Str],
    ];

coerce ProtectionTable,
    from Str,
    via {
        my $p = $_;
        +{ map { $_ => $p } qw(accessor reader writer predicate clearer) };
    };

around "_process_accessors" => sub {
    my $orig = shift;
    my $self = shift;

    my $type = $_[0];

    my $name = $self->name;
    my $class = $self->associated_class->name;

    my $protection = $self->protection;
    map { $protection->{$_} ||= "private" } @types;

    return $self->$orig(@_) if $protection->{$type} eq "public";

    my ($method, $code) = $self->$orig(@_);

    my $wrap = Class::MOP::Method::Wrapped->wrap($code);

    # private. the caller must be in the same class that the object is blessed into
    if ($protection->{$type} eq "private") {
        $wrap->add_around_modifier(sub {
            my $orig = shift;
            my ($self) = @_;

            my $n = 0;
            my $caller;
            while (($caller = caller($n++)) eq "Class::MOP::Method::Wrapped") { }

            if ($caller ne ref $self) {
                confess "Method '$method' in class '$class' is private";
            }

            goto $orig;
        });
    }

    # protected. the caller must be in the same class or one of of the
    # subclasses of that which the object is blessed into
    elsif ($protection->{$type} eq "protected") {
        $wrap->add_around_modifier(sub {
            my $orig = shift;
            my ($self) = @_;

            my $n = 0;
            my $caller;
            while (($caller = caller($n++)) eq "Class::MOP::Method::Wrapped") { }

            if (!($caller eq ref $self || $self->isa($caller))) {
                confess "Method '$method' in class '$class' is protected";
            }

            goto $orig;
        });
    }

    return ($method, $wrap);
};

meta_attribute_alias("Protected");

no Moose::Role;

1;
