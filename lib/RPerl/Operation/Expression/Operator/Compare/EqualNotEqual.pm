# [[[ HEADER ]]]
package RPerl::Operation::Expression::Operator::Compare::EqualNotEqual;
use strict;
use warnings;
use RPerl::AfterSubclass;
our $VERSION = 0.002_000;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::Operation::Expression::Operator::Compare);
use RPerl::Operation::Expression::Operator::Compare;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ OO PROPERTIES ]]]
our hashref $properties = {};

# [[[ OO METHODS & SUBROUTINES ]]]

our string_hashref::method $ast_to_rperl__generate = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $rperl_source_group = { PMC => q{} };

   #    RPerl::diag( 'in Operator::Compare::EqualNotEqual->ast_to_rperl__generate(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    my string $self_class = ref $self;
    if ( $self_class eq 'Operator_101' ) {    # Operator -> SubExpression OP12_COMPARE_EQ_NE SubExpression
        if (    ( $self->{children}->[1] ne '==' )
            and ( $self->{children}->[1] ne '!=' )
            and ( $self->{children}->[1] ne 'eq' )
            and ( $self->{children}->[1] ne 'ne' ) )
        {
            die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASRP28, CODE GENERATOR, ABSTRACT SYNTAX TO RPERL: comparison operator '
                    . $self->{children}->[1]
                    . ' found where ==, !=, eq, or ne expected, dying' )
                . "\n";
        }

        my string_hashref $rperl_source_subgroup = $self->{children}->[0]->ast_to_rperl__generate($modes);
        RPerl::Generator::source_group_append( $rperl_source_group, $rperl_source_subgroup );
        $rperl_source_group->{PMC} .= q{ } . $self->{children}->[1] . q{ };
        $rperl_source_subgroup = $self->{children}->[2]->ast_to_rperl__generate($modes);
        RPerl::Generator::source_group_append( $rperl_source_group, $rperl_source_subgroup );
    }
    else {
        die RPerl::Parser::rperl_rule__replace(
            'ERROR ECOGEASRP00, CODE GENERATOR, ABSTRACT SYNTAX TO RPERL: grammar rule ' . $self_class . ' found where Operator_101 expected, dying' )
            . "\n";
    }

    return $rperl_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_PERLTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{// <<< RP::O::E::O::C::ENE __DUMMY_SOURCE_CODE CPPOPS_PERLTYPES >>>} . "\n" };

    #...
    return $cpp_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_CPPTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{} };

#    RPerl::diag( 'in Operator::Compare::EqualNotEqual->ast_to_cpp__generate__CPPOPS_CPPTYPES(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    my string $self_class = ref $self;
    if ( $self_class eq 'Operator_101' ) {    # Operator -> SubExpression OP12_COMPARE_EQ_NE SubExpression
        my string_hashref $cpp_source_subgroup = $self->{children}->[0]->ast_to_cpp__generate__CPPOPS_CPPTYPES($modes);
        RPerl::Generator::source_group_append( $cpp_source_group, $cpp_source_subgroup );
        if ( ( $self->{children}->[1] eq '==' ) or ( $self->{children}->[1] eq '!=' ) ) {
            $cpp_source_group->{CPP} .= q{ } . $self->{children}->[1] . q{ };
        }
        elsif ( $self->{children}->[1] eq 'eq' ) {
            $cpp_source_group->{CPP} .= ' == ';    # DEV NOTE: '==' is an overload for std::string::compare()
        }
        elsif ( $self->{children}->[1] eq 'ne' ) {
            $cpp_source_group->{CPP} .= ' != ';    # DEV NOTE: '!=' is an overload for not(std::string::compare())
        }
        else {
            die RPerl::Parser::rperl_rule__replace( 'ERROR ECOGEASCP28, CODE GENERATOR, ABSTRACT SYNTAX TO C++: comparison operator '
                    . $self->{children}->[1]
                    . ' found where ==, !=, eq, or ne expected, dying' )
                . "\n";
        }
        $cpp_source_subgroup = $self->{children}->[2]->ast_to_cpp__generate__CPPOPS_CPPTYPES($modes);
        RPerl::Generator::source_group_append( $cpp_source_group, $cpp_source_subgroup );
    }
    else {
        die RPerl::Parser::rperl_rule__replace(
            'ERROR ECOGEASCP00, CODE GENERATOR, ABSTRACT SYNTAX TO C++: grammar rule ' . $self_class . ' found where Operator_101 expected, dying' )
            . "\n";
    }

    return $cpp_source_group;
};

1;    # end of class
