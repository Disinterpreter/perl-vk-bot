package commands::ltools;
use commands::commandHandler;
use FindBin;
use lib "$FindBin::Bin";

use requests::sender;
use Data::Dumper;
use JSON;
use utf8;
use LWP;
use LWP::UserAgent; 


my $ua      = LWP::UserAgent->new();

sub urban {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    warn($message);
    $message =~ s/\s+/%20/g;
    my $url = 'https://api.urbandictionary.com/v0/define?term='.$message;
    my $request = $ua->get( $url );
    my $response = $request->decoded_content;
    my $jstring = decode_json($response);
    my @definitions = ();
    push @definitions, "Урбан варианты данного слова:\n";
    for (my $i = 0; $i < 5; $i++ ) {
        push @definitions, "$i:<br>".$jstring->{'list'}->[$i]->{'definition'}."<br>------------";
    }
    warn(Dumper(@definitions));

    my $resp = join '<br><br>', @definitions;
    $resp =~ s/[\[\]]//gm;
    requests::sender::message_send($peer_id,$resp);
}


sub cleaner {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    if ($message =~ m/Dialogue: [^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*),(.*)/gm) {
        $message =~ s/Dialogue: [^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*),(.*)/$2/gm;
        $message =~ s/{.*}//gmu;
        requests::sender::message_send($peer_id,$message);
    } else {
        requests::sender::message_send($peer_id,"юзай хелп");
    }


}
commands::commandHandler::createCommand("урбан", \&urban);
commands::commandHandler::createCommand("чисти", \&cleaner);
1;
