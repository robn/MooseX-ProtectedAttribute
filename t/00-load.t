#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'MooseX::ProtectedAttribute' ) || print "Bail out!
";
}

diag( "Testing MooseX::ProtectedAttribute $MooseX::ProtectedAttribute::VERSION, Perl $], $^X" );
