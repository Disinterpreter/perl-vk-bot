package commands::games;
use commands::commandHandler;
use FindBin;
use lib "$FindBin::Bin";

use LWP;
use LWP::UserAgent; 

use JSON;

use requests::sender;
use Data::Dumper;
use utf8;

use Switch;

use config::configReader;
my $config = config::configReader::loadConfig('.env');


sub league {
    my $ua      = LWP::UserAgent->new();
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    my $peer_id = $_[0]->{'object'}->{'peer_id'};

    my $allchampsurl = 'http://ddragon.leagueoflegends.com/cdn/6.24.1/data/ru_RU/champion.json';
    my $getRchamps = $ua->get( $allchampsurl );
    my $responseChamps = $getRchamps->decoded_content;
    my $jsonChamps = decode_json($responseChamps);
    my $onlyChamps = $jsonChamps->{'data'};

    my @args = split(' ', $message);
    # в свитче что-то стало деприкейтед, флудит в консоль
    # позже починят, я надеюсь
    switch($args[0]) {
        case /ротация/ {
            my $url = 'https://ru.api.riotgames.com/lol/platform/v3/champion-rotations?api_key='.$config->{'LEAGUE'};
            my $request = $ua->get( $url );
            my $response = $request->decoded_content;
            my $jstring = decode_json($response);
            my $rotlist = $jstring->{'freeChampionIds'};
            
            my @rotationmessage = ();
            push @rotationmessage, "Ротация недели: <br>";

            foreach my $id (keys @$rotlist) {
                my $rotationCharId = $rotlist->[$id];
                #warn ($rotationCharId)
                foreach my $name (sort keys %$onlyChamps) {
                    my $champid = $onlyChamps->{$name}->{'key'};
                    if ($rotationCharId eq $champid) {
                        my $champname = $onlyChamps->{$name}->{'name'};
                        push @rotationmessage, "᛫ ".$champname."<br>";
                    }
                }
            }
            my $rotmsgsend = join(' ', @rotationmessage);
            requests::sender::message_send($peer_id, $rotmsgsend);
        }
        else {
            requests::sender::message_send($peer_id,"Юзай хельп");
        }
    }
}

commands::commandHandler::createCommand("лига", \&league);