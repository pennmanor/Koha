#!/usr/bin/perl

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
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA

use Modern::Perl;

use CGI;
use C4::Auth qw/:DEFAULT get_session/;

my $input = new CGI;

my $cookie =~ m/CGISESSID=(\w*);.*/;
my $sessionID = $1;
my $session   = get_session($sessionID);

if ( $input->param('newbranch') ) {
    $session->param( 'mylibraryfirst', $input->param('newbranch') );
    $session->param( 'branch',         $input->param('newbranch') );
}
else {
    $session->param( 'mylibraryfirst', undef );
    $session->param( 'branch',         undef );
}

$session->flush;

print $input->redirect('/cgi-bin/koha/opac-main.pl');

