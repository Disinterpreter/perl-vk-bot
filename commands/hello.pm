package commands::hello;
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

my $config = config::configReader::loadConfig('.env');

sub version {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $version = `git rev-list HEAD | head -n 1`;
    my $send = "Версия коммита: ". $version . "<br>".
    "Детали:<br> https://github.com/Disinterpreter/perl-vk-bot/commit/".$version."";
    requests::sender::message_send($peer_id,$send);
}

sub hello {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    warn("Hello! :japanese_goblin: \n");
    requests::sender::message_sticker_send($peer_id,9053);
}


my @groups = (
    -40232010,
    -92876084,
    -150550417,
    -73598440,
    -155464693,
    -148583957,
    -139441547,
    -93082454,
    #-26406986,
    -164517505
);

my @boringmems = (
    -33414947,
    -31976785,
    -31480508,
    -72378974,
    -30602036,
    -46448985,
    -26419239,
    -12382740,
    -91050183
);
sub humor {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = '';
    # Типа peer_id у нас определенная конфа с ценузрой
    # Поэтому мы туда впихаем скучные мемзы :)
    if ($peer_id eq '2000000003' || $peer_id eq '2000000006') {
        $post = requests::sender::wall_get(@boringmems);
    } else {
        $post = requests::sender::wall_get(@groups);
    };
    requests::sender::message_send($peer_id,'', $post);
    #warn(Dumper($jconf->{'response'}->{'items'}->[0]->{'id'}))

}

sub hw {
    my @hw = (
        -171298409,
        -117665805,
        -174790096,
        -174056018,
        -14317987,
        -179183534
    );
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@hw);
    requests::sender::message_send($peer_id,'', $post);
};

my @fem = (
    -154213818,
    -110664178,
    -105683933,
    -113292858,
    -167074015,
    -108546632,
    -144308229,
    -51889526
#    146030787
);
sub fem {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@fem);
    requests::sender::message_send($peer_id,'', $post);
    #warn(Dumper($jconf->{'response'}->{'items'}->[0]->{'id'}))

}

sub boxes {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my @photo = requests::sender::photo_get_random("478080307","259469122");
    requests::sender::message_send($peer_id,$photo[1], $photo[0]);
    #requests::sender::message_send($peer_id,'', $post);
}

my @videog = (
    #-117257213, # too hot
    -111096931,
    -95254073,
    -102087446,
    -108338390
);
sub videos {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = '';
    # Типа peer_id у нас определенная конфа с ценузрой
    # Поэтому мы туда запретим доступ :)
    my $video = '';
    if ($peer_id eq '2000000003' || $peer_id eq '2000000006') {
        #requests::sender::message_sticker_send($peer_id,6877);
        $video = requests::sender::video_get_random(['-26919587']);
        requests::sender::message_send($peer_id,'', $video);
        return;
    } else {
        $video = requests::sender::video_get_random(@videog);
        requests::sender::message_send($peer_id,'', $video);
    };
    #my $video = requests::sender::video_get_random(@videog);
    #requests::sender::message_send($peer_id,'', $video);
    #requests::sender::message_send($peer_id,'', $post);
}

sub oks {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $ua      = LWP::UserAgent->new();
    my $url = 'https://gist.githubusercontent.com/continue98/5608a7740d96141df32fa79d01ab6750/raw/72ba3754073c0a1665851404c139af3862cd4888/oks.json';
    my $request = $ua->get( $url );
    my $response = $request->decoded_content;
    $response =~ s/© OKStyle™//gm;
    my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
    my $jstring = $coder->decode($response);
    my $quote = $jstring->{'Quotes'}->[int(rand(59))]->{'plain_text'};
    requests::sender::message_send($peer_id,$quote);
    #requests::sender::message_send($peer_id,'', $post);
}

sub advice {
    
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $ua      = LWP::UserAgent->new();
    my $url = 'http://fucking-great-advice.ru/api/random';
    my $request = $ua->get( $url );
    my $response = $request->decoded_content;
    my $coder = JSON::XS->new->utf8->pretty->allow_nonref;
    my $jstring = $coder->decode($response);
    my $quote = $jstring->{'text'};
    requests::sender::message_send($peer_id,$quote);
}

sub krovostok {
    my @kvaudio = (
        'audio371745430_456296056',
        'audio371745435_456296610',
        'audio371745435_456296606',
        'audio371745460_456296378',
        'audio371745436_456296425',
        'audio371745456_456296217',
        'audio371745445_456570842',
        'audio371745434_456571867',
        'audio371745451_456569171'

    );
    my $audio = splice(@kvaudio, rand @kvaudio, 1);
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    # Наша цензура такое точно не пропустит
    if ($peer_id ne '2000000003') {
        my $peer_id = $_[0]->{'object'}->{'peer_id'};
        requests::sender::message_send($peer_id,'', $audio);
    } else {
        requests::sender::message_sticker_send($peer_id,10379);
    }
}


sub elizabeth {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    my $fromid = $_[0]->{'object'}->{'from_id'};
    $message =~ s/^\w+\s+\w+\s+//g;
    if ($message =~ m/глину/g) {
        #if ($config->{'ELIZA'} eq $fromid || $config->{'OWNER'} eq $fromid) {
            my @photo = requests::sender::photo_get_random("-179588896","263047835");
            requests::sender::message_send($peer_id,$photo[1], $photo[0]);
        #} else {
        #    requests::sender::message_sticker_send($peer_id,9986);
        #}
        #requests::sender::message_send($peer_id,'', $post);
    };

}

commands::commandHandler::createCommand("меси", \&elizabeth);
commands::commandHandler::createCommand("кровосток", \&krovostok);
commands::commandHandler::createCommand("хв", \&hw);
commands::commandHandler::createCommand("совет", \&advice);
commands::commandHandler::createCommand("окс", \&oks);
commands::commandHandler::createCommand("коробочка", \&boxes);
commands::commandHandler::createCommand("юмор", \&humor);
commands::commandHandler::createCommand("мем", \&humor);
commands::commandHandler::createCommand("вебм", \&videos);
commands::commandHandler::createCommand("шебм", \&videos);
commands::commandHandler::createCommand("видео", \&videos);
commands::commandHandler::createCommand("привет", \&hello);
commands::commandHandler::createCommand("версия", \&version);
commands::commandHandler::createCommand("фем", \&fem);
commands::commandHandler::createCommand("хуемрази", \&fem);
commands::commandHandler::createCommand("хуемразь", \&fem);
commands::commandHandler::createCommand("хуе-мрази", \&fem);
1;
