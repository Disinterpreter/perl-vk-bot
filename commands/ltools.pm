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

use XML::Feed;
use URI::Encode qw(uri_encode uri_decode);


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

sub nyaa {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;

    my $formatted = uri_encode($message);
    $ua->timeout( 3 );
    my $feed = XML::Feed->parse(URI->new('https://nyaa1.unblocked.lol/?page=rss&c=1_2&f=0&q='.$formatted))
    or requests::sender::message_send($peer_id, XML::Feed->errstr);
    if (!defined $feed) {
     return [
             '200',
             [ 'Content-Type' => 'text/html' ],
             [ "ok" ],
        ];        
     };
    # my $title = $feed->item->title;
    # my $link = $feed->item->link;
    if ( scalar($feed->entries) == 0) { requests::sender::message_send($peer_id, "Я ничего не нашел"); };
    for my $entry ($feed->entries) {
        requests::sender::upload_doc($entry->{'entry'}->{'link'}, $entry->{'entry'}->{'title'}, $peer_id);
        last;
    }
    
}

commands::commandHandler::createCommand("няшка", \&nyaa);
commands::commandHandler::createCommand("урбан", \&urban);
commands::commandHandler::createCommand("чисти", \&cleaner);
1;
