
package commands::nika;
use commands::commandHandler;
use FindBin;
use lib "$FindBin::Bin";

use strict;
use warnings;
use LWP;
use LWP::UserAgent; 
use config::configReader;

use JSON::XS;

use requests::sender;
use Data::Dumper;
use utf8;
use feature "switch";

my $config = config::configReader::loadConfig('.env');



sub persona {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    #if ($message =~ m/глину/g) {
    my @photo = requests::sender::photo_get_random("304061977","265451323");
    requests::sender::message_send($peer_id,$photo[1], $photo[0]);
    #};

};

sub personochka {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    if ($message =~ m/очка/g) {
        my @photo = requests::sender::photo_get_random("304061977","265451369");
        requests::sender::message_send($peer_id,$photo[1], $photo[0]);
    };

};

sub igor {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    if ($message =~ m/я игорь/g) {
        my @photo = requests::sender::photo_get_random("304061977","265453337");
        requests::sender::message_send($peer_id,$photo[1], $photo[0]);
    };

};

commands::commandHandler::createCommand("персона", \&persona);
commands::commandHandler::createCommand("персон", \&persona);
commands::commandHandler::createCommand("какой", \&igor);