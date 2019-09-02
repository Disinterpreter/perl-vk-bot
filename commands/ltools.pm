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
use HTTP::Request;
use HTML::TreeBuilder::XPath qw();

use XML::Feed;
use URI::Encode qw(uri_encode uri_decode);


my $ua      = LWP::UserAgent->new();

sub urban {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
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
    $ua->timeout( 10 );
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
    my $doc = '';
    my $title = '';
    for my $entry ($feed->entries) {
        warn("count");
        $title = $entry->{'entry'}->{'title'};
        my $linkoftitle = $entry->{'entry'}->{'link'};
        $linkoftitle =~ s/nyaa\.si/nyaa1\.unblocked\.lol/g;
        warn ($linkoftitle);
        $doc = requests::sender::upload_doc($entry->{'entry'}->{'link'}, $entry->{'entry'}->{'title'}, $peer_id);      
        last;
    }
    requests::sender::message_send($peer_id,$title,$doc);
    
}

sub sendreqtomtran {
    #my $var;
    #system("curl -s --location --request GET https://www.multitran.com/m.exe?s=shovel&l1=1&l2=2", $var);
    my $dicua      = LWP::UserAgent->new();
    $dicua->agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36');
    my $dicresp = $dicua->get( 'https://www.multitran.com/m.exe?s='.$_[0].'&l1=1&l2=2');
    undef $dicua;
    return $dicresp->decoded_content();
    #return $var;
}
sub multitran {
    
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;

    warn ($message);

    my $output;
    # if ($message =~ m/[А-я \-_ ]+/gmu) {
        $output = sendreqtomtran($message);
    # } else {
    #     $output = sendreqtomtran($message);       
    # }
    my $content = $output;
    my $t = HTML::TreeBuilder::XPath->new;
    $t->parse_content($content);
    warn ($t);
    # class="mt-4 p-4 shadow-sm rounded"
    #my $comments = $t->findvalue('//*[@width="100%"]');
    my @subj = $t->findvalues('//*[@class="subj"]');
    my @trans = $t->findvalues('//*[@class="trans"]');


    #print(Dumper(@trans));

    #my $mtran = {};
    my @definition = ();
    if ( scalar(@subj) == scalar(@trans) ) {
        for (my $dic = 0; $dic <= 7; $dic++) {
        #foreach my $dic ( keys @subj) {
            #$mtran->{$subj[$dic]} = $trans[$dic];
            my $def = $subj[$dic] . "   :   ". $trans[$dic];
            push @definition, $def;
            #warn ($subj[$dic] . "   :   ". $trans[$dic] . "\n");
        }
    #    print(Dumper( scalar(@trans)));
    }
    my $endstr = join('<br>', @definition);
    warn (Dumper($endstr));
    requests::sender::message_send($peer_id,$endstr);

    #warn(Dumper($mtran));
}

commands::commandHandler::createCommand("мтран", \&multitran);
commands::commandHandler::createCommand("мультитран", \&multitran);
commands::commandHandler::createCommand("м", \&multitran);
commands::commandHandler::createCommand("multitran", \&multitran);
commands::commandHandler::createCommand("m", \&multitran);

commands::commandHandler::createCommand("няшка", \&nyaa);
commands::commandHandler::createCommand("урбан", \&urban);
commands::commandHandler::createCommand("чисти", \&cleaner);
1;
