package Koha::ItemType;

# This represents a single itemtype

# Copyright 2014 Catalyst IT
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

=head1 NAME

Koha::ItemType - represents a single itemtype

=head1 DESCRIPTION

This contains the data relating to a single itemtype

=head1 SYNOPSIS

    use Koha::ItemTypes;
    my $types = Koha::ItemTypes->new();
    my $type  = $types->get_itemtype('CODE');
    print $type->code, $type->description, $type->rentalcharge,
      $type->imageurl, $type->summary, $type->checkinmsg,
      $type->checkinmsgtype;

Creating an instance of C<Koha::ItemType> without using L<Koha::ItemTypes>
can be done simply by passing a hashref containing the values to C<new()>.
Note when doing this that a value for C<itemtype> will become a value for
C<code>.

=head1 FUNCTIONS

In addition to the read-only accessors mentioned above, the following functions
exist.

=cut

use Modern::Perl;

use base qw(Class::Accessor);

# TODO can we make these auto-generate from the input hash so it doesn't
# have to be updated when the database is?
__PACKAGE__->mk_ro_accessors(
    qw(code description rentalcharge imageurl
      summary checkinmsg checkinmsgtype)
);

sub new {
    my $class = shift @_;

    my %data = ( %{ $_[0] }, code => $_[0]->{itemtype} );
    my $self = $class->SUPER::new( \%data );
    return $self;
}

1;
