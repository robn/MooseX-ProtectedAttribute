use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MooseX::ProtectedAttribute',
    AUTHOR              => q{Robert Norris <rob@cataclysm.cx>},
    VERSION_FROM        => 'lib/MooseX/ProtectedAttribute.pm',
    ABSTRACT_FROM       => 'lib/MooseX/ProtectedAttribute.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-ProtectedAttribute-*' },
);
