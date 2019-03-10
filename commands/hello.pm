package commands::hello;
use commands::commandHandler;
use FindBin;
use lib "$FindBin::Bin";

use strict;
use warnings;
use LWP;
use LWP::UserAgent; 

use JSON;

use requests::sender;
use Data::Dumper;
use utf8;

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
    -26406986
);
sub humor {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@groups);
    requests::sender::message_send($peer_id,'', $post);
    #warn(Dumper($jconf->{'response'}->{'items'}->[0]->{'id'}))

}

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
    my $video = requests::sender::video_get_random(@videog);
    requests::sender::message_send($peer_id,'', $video);
    #requests::sender::message_send($peer_id,'', $post);
}

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
