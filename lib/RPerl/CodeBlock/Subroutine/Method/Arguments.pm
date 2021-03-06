# [[[ HEADER ]]]
package RPerl::CodeBlock::Subroutine::Method::Arguments;
use strict;
use warnings;
use RPerl::AfterSubclass;
our $VERSION = 0.003_200;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::CodeBlock::Subroutine::Arguments);
use RPerl::CodeBlock::Subroutine::Arguments;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ INCLUDES ]]]
use Storable qw(dclone);

# [[[ OO PROPERTIES ]]]
our hashref $properties = {};

# [[[ OO METHODS & SUBROUTINES ]]]

our string_hashref::method $ast_to_rperl__generate = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $rperl_source_group = { PMC => q{} };
    my string_hashref $rperl_source_subgroup;

#    RPerl::diag( 'in Method::Arguments->ast_to_rperl__generate(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    # MethodArguments -> LPAREN_MY Type SELF (OP21_LIST_COMMA MY Type VARIABLE_SYMBOL)* ')' OP19_VARIABLE_ASSIGN '@_;'
    my string $lparen_my               = $self->{children}->[0];
    my object $self_type               = $self->{children}->[1];
    my string $self_symbol             = $self->{children}->[2];
    my object $arguments_star          = $self->{children}->[3];
    my string $rparen                  = $self->{children}->[4];
    my string $equal                   = $self->{children}->[5];
    my string $at_underscore_semicolon = $self->{children}->[6];

    $rperl_source_group->{PMC} .= $lparen_my . q{ } . $self_type->{children}->[0] . q{ } . $self_symbol;

    # (OP21_LIST_COMMA MY Type VARIABLE_SYMBOL)*
    my object $arguments_star_dclone = dclone($arguments_star);
    while ( exists $arguments_star_dclone->{children}->[0] ) {
        my object $comma = shift @{ $arguments_star_dclone->{children} };
        my object $my    = shift @{ $arguments_star_dclone->{children} };
        my object $type  = shift @{ $arguments_star_dclone->{children} };
        my object $name  = shift @{ $arguments_star_dclone->{children} };
        # strings inside of STAR grammar production becomes TERMINAL object, must retrieve data from attr property
        $rperl_source_group->{PMC} .= $comma->{attr} . q{ } . $my->{attr} . q{ } . $type->{children}->[0] . q{ } . $name->{attr};
    }

    $rperl_source_group->{PMC} .= q{ } . $rparen . q{ } . $equal . q{ } . $at_underscore_semicolon . "\n";
    return $rperl_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_PERLTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{// <<< RP::CB::S::M::A __DUMMY_SOURCE_CODE CPPOPS_PERLTYPES >>>} . "\n" };

    #...
    return $cpp_source_group;
};

our string_hashref::method $ast_to_cpp__generate__CPPOPS_CPPTYPES = sub {
    ( my object $self, my string_hashref $modes) = @_;
    my string_hashref $cpp_source_group = { CPP => q{} };
    my string_hashref $cpp_source_subgroup;

   #    RPerl::diag( 'in Method::Arguments->ast_to_cpp__generate__CPPOPS_CPPTYPES(), received $self = ' . "\n" . RPerl::Parser::rperl_ast__dump($self) . "\n" );

    my object $arguments_star = $self->{children}->[3];

    my string_arrayref $arguments = [];
    # discard trailing '::' to go from namespace to class-name-as-type
    $modes->{_symbol_table}->{ $modes->{_symbol_table}->{_namespace} }->{ $modes->{_symbol_table}->{_subroutine} }->{this} = {
        isa  => 'RPerl::CodeBlock::Subroutine::Arguments',
        type => ( substr $modes->{_symbol_table}->{_namespace}, 0, ( ( length $modes->{_symbol_table}->{_namespace} ) - 2 ) )
    };

#RPerl::diag( 'in Method::Arguments->ast_to_cpp__generate__CPPOPS_CPPTYPES(), have $arguments_star = ' . "\n" . RPerl::Parser::rperl_ast__dump($arguments_star) . "\n" );

    # (OP21_LIST_COMMA MY Type VARIABLE_SYMBOL)*
    my object $arguments_star_dclone = dclone($arguments_star);
    while ( exists $arguments_star_dclone->{children}->[0] ) {
        shift @{ $arguments_star_dclone->{children} };    # discard $comma
        shift @{ $arguments_star_dclone->{children} };    # discard $my
        my object $arguments_type = shift @{ $arguments_star_dclone->{children} };
        my string $arguments_name = shift @{ $arguments_star_dclone->{children} };
        $arguments_name = $arguments_name->{attr};  # strings inside of STAR grammar production becomes TERMINAL object, must retrieve data from attr property
        substr $arguments_name, 0, 1, q{};        # remove leading $ sigil

        $modes->{_symbol_table}->{ $modes->{_symbol_table}->{_namespace} }->{ $modes->{_symbol_table}->{_subroutine} }->{ $arguments_name }
            = { isa => 'RPerl::CodeBlock::Subroutine::Method::Arguments', type => $arguments_type->{children}->[0] };
        $arguments_type->{children}->[0] =~ s/^constant_/const\ /gxms;    # 'constant_foo' becomes 'const foo'
        $arguments_type->{children}->[0] =~ s/::/__/gxms;                 # 'Class::Subclass' becomes 'Class__Subclass'
        push @{$arguments}, ( $arguments_type->{children}->[0] . q{ } . $arguments_name );
    }
    $cpp_source_group->{CPP} .= join ', ', @{$arguments};
    return $cpp_source_group;
};

1;                                                                        # end of class
