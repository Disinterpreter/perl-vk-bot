package commands::hello;
use commands::commandHandler;
use FindBin;
use lib "$FindBin::Bin";

use LWP;
use LWP::UserAgent; 

use JSON;

use requests::sender;
use Data::Dumper;
use utf8;

sub hello {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    warn("Hello! :japanese_goblin: \n");
    requests::sender::message_sticker_send($peer_id,9053);
}


my @groups = (
    -40232010,
    -92876084,
    -150550417,
    -73598440
);
sub humor {
    my $clid = splice(@groups, rand @groups, 1);
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get($clid);
    requests::sender::message_send($peer_id,'', $post);
    #warn(Dumper($jconf->{'response'}->{'items'}->[0]->{'id'}))

}

sub boxes {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my @photo = requests::sender::photo_get_random("478080307","259469122");
    requests::sender::message_send($peer_id,$photo[1], $photo[0]);
    #requests::sender::message_send($peer_id,'', $post);
}

sub videos {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $video = requests::sender::video_get_random(-30316056);
    requests::sender::message_send($peer_id,'', $video);
    #requests::sender::message_send($peer_id,'', $post);
}

commands::commandHandler::createCommand("коробочка", \&boxes);
commands::commandHandler::createCommand("юмор", \&humor);
commands::commandHandler::createCommand("вебм", \&videos);
commands::commandHandler::createCommand("видео", \&videos);
commands::commandHandler::createCommand("привет", \&hello);

1;
