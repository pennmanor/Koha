package Koha::ItemTypes;

# This contains the item types that the system knows about.

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

Koha::ItemTypes - handles the item types that Koha knows about

=head1 DESCRIPTION

This contains functions to access the item types.

Note that any changes that happen to the database while this object is live
may not be reflected, so best don't hold onto it for a long time

=cut

use Koha::Database;
use Koha::ItemType;
use Modern::Perl;

use Data::Dumper; # TODO remove
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw());

=head1 FUNCTIONS

=head2 new

    my $itypes = Koha::ItemTypes->new();

Creates a new instance of the object.

=cut

# Handled by Class::Accessor

=head2 get_itemtype

    my @itype = $itypes->get_itemtype('CODE1', 'CODE2');

This returns a L<Koha::ItemType> object for each of the provided codes. For
any that don't exist, an C<undef> is returned.

=cut

sub get_itemtype {
    my ($self, @codes) = @_;

    my $schema = Koha::Database->new()->schema();
    my @res;

    foreach my $c (@codes) {
        if (exists $self->{cached}{$c}) {
            push @res, $self->{cached}{$c};
            next;
        }
        my $rs = $schema->resultset('Itemtype')->search( { itemtype => $c } );
        my $r = $rs->next;
        if (!$r) {
            push @res, undef;
            next;
        }
        my %data = $r->get_inflated_columns;
        my $it = Koha::ItemType->new(\%data);
        push @res, $it;
        $self->{cached}{$c} = $it;
    }
    if (wantarray) {
        return @res;
    } else {
        return @res ? $res[0] : undef;
    }
}

=head2 get_description_for_code

    my $desc = $itypes->get_description_for_code($code);

This returns the description for an itemtype code. As a special case, if
there is no itemtype for this code, it'll return what it was given.

It is mostly as a convenience function rather than using L<get_itemtype>.

=cut

sub get_description_for_code {
    my ($self, $code) = @_;

    my $itype = $self->get_itemtype($code);
    return $code if !$itype;
    return $itype->description;
}

1;
