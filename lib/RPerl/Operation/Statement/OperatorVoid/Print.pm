# [[[ HEADER ]]]
package RPerl::Operation::Statement::OperatorVoid::Print;
use strict;
use warnings;
use RPerl::AfterSubclass;
our $VERSION = 0.003_200;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::Operation::Statement::OperatorVoid);
use RPerl::Operation::Statement::OperatorVoid;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ OO PROPERTIES ]]]
our hashref $properties = {};

# [[[ OO METHODS & SUBROUTINES ]]]

our string_hashref::method $ast_to_rperl__generate = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $rperl_source_group = { PMC => q{} };
    my string_hashref $rperl_source_subgroup;

    #    RPerl::diag( 'in OperatorVoid::Print->ast_to_rperl__generate(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    my string $self_class = ref $self;
    if ( $self_class eq 'OperatorVoid_116' ) {    # OperatorVoid -> OP01_PRINT OPTIONAL-31 ListElements ';'
        my string $print                  = $self->{children}->[0];
        my object $stdout_stderr_optional = $self->{children}->[1];
        my object $list_elements          = $self->{children}->[2];
        my string $semicolon              = $self->{children}->[3];

#        RPerl::diag( 'in OperatorVoid::Print->ast_to_rperl__generate(), have $stdout_stderr_optional = ' . "\n" . RPerl::Parser::rperl_ast__dump($stdout_stderr_optional) . "\n" );

        $rperl_source_group->{PMC} .= $print . q{ };

        if ( exists $stdout_stderr_optional->{children}->[0] ) {
            if ( ( $stdout_stderr_optional->{children}->[0]->{attr} ne '{*STDOUT}' ) and ( $stdout_stderr_optional->{children}->[0]->{attr} ne '{*STDERR}' ) ) {
                die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASRP27, CODE GENERATOR, ABSTRACT SYNTAX TO RPERL: output stream '
                        . $stdout_stderr_optional->{children}->[0]->{attr}
                        . ' found where {*STDOUT} or {*STDERR} expected, dying' )
                    . "\n";
            }

# DEV NOTE: STDOUT & STDERR are generated below, they are only grammar tokens, not grammar rules, so they do not get their own classes, the following do not exist:
# RPerl::InputOutput::Stderr & RPerl::InputOutput::Stdout
            $rperl_source_group->{PMC} .= $stdout_stderr_optional->{children}->[0]->{attr} . q{ };
        }

        $rperl_source_subgroup = $list_elements->ast_to_rperl__generate($modes);
        RPerl::Generator::source_group_append( $rperl_source_group, $rperl_source_subgroup );
        $rperl_source_group->{PMC} .= $semicolon . "\n";
    }
    elsif ( $self_class eq 'OperatorVoid_117' ) {    # OperatorVoid -> OP01_PRINT FHREF_SYMBOL_BRACES ListElements ';'
        my string $print               = $self->{children}->[0];
        my string $fhref_symbol_braces = $self->{children}->[1];
        my object $list_elements       = $self->{children}->[2];
        my string $semicolon           = $self->{children}->[3];

        $rperl_source_group->{PMC} .= $print . q{ } . $fhref_symbol_braces . q{ };
        $rperl_source_subgroup = $list_elements->ast_to_rperl__generate($modes);
        RPerl::Generator::source_group_append( $rperl_source_group, $rperl_source_subgroup );
        $rperl_source_group->{PMC} .= $semicolon . "\n";
    }
    else {
        die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASRP00, CODE GENERATOR, ABSTRACT SYNTAX TO RPERL: grammar rule '
                . $self_class
                . ' found where OperatorVoid_116 or OperatorVoid_117 expected, dying' )
            . "\n";
    }

    return $rperl_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_PERLTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{// <<< RP::O::S::OV::P __DUMMY_SOURCE_CODE CPPOPS_PERLTYPES >>>} . "\n" };

    #...
    return $cpp_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_CPPTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{} };
    my string_hashref $cpp_source_subgroup;

 #    RPerl::diag( 'in OperatorVoid::Print->ast_to_cpp__generate__CPPOPS_CPPTYPES(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    my string $self_class = ref $self;
    if ( $self_class eq 'OperatorVoid_116' ) {    # OperatorVoid -> OP01_PRINT OPTIONAL-31 ListElements ';'
        my object $stdout_stderr_optional = $self->{children}->[1];
        my object $list_elements          = $self->{children}->[2];
        my string $semicolon              = $self->{children}->[3];

#        RPerl::diag( 'in OperatorVoid::Print->ast_to_cpp__generate__CPPOPS_CPPTYPES(), have $stdout_stderr_optional = ' . "\n" . RPerl::Parser::rperl_ast__dump($stdout_stderr_optional) . "\n" );

        if ( exists $stdout_stderr_optional->{children}->[0] ) {
            if ( $stdout_stderr_optional->{children}->[0]->{attr} eq '{*STDOUT}' ) {
                $cpp_source_group->{CPP} .= 'cout << ';
            }
            elsif ( $stdout_stderr_optional->{children}->[0]->{attr} eq '{*STDERR}' ) {
                $cpp_source_group->{CPP} .= 'cerr << ';
            }
            else {
                die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASCP27, CODE GENERATOR, ABSTRACT SYNTAX TO C++: output stream '
                        . $stdout_stderr_optional->{children}->[0]->{attr}
                        . ' found where {*STDOUT} or {*STDERR} expected, dying' )
                    . "\n";
            }
        }
        else {
            $cpp_source_group->{CPP} .= 'cout << ';
        }
        $cpp_source_subgroup = $list_elements->ast_to_cpp__generate__CPPOPS_CPPTYPES($modes);
        RPerl::Generator::source_group_append( $cpp_source_group, $cpp_source_subgroup );
        $cpp_source_group->{CPP} .= $semicolon . "\n";
    }
    elsif ( $self_class eq 'OperatorVoid_117' ) {    # OperatorVoid -> OP01_PRINT FHREF_SYMBOL_BRACES ListElements ';'
        $cpp_source_group->{CPP} .= '// <<< RP::O::S::OV::P __DUMMY_SOURCE_CODE CPPOPS_CPPTYPES >>>' . "\n";
    }
    else {
        die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASCP00, CODE GENERATOR, ABSTRACT SYNTAX TO C++: grammar rule '
                . $self_class
                . ' found where OperatorVoid_116 or OperatorVoid_117 expected, dying' )
            . "\n";
    }

    return $cpp_source_group;
};

1;    # end of class
