package requests::sender;

use LWP;
use LWP::UserAgent; 

use lib '../';
use config::configReader;
use warnings;
use strict;
use JSON;
use Data::Dumper;

my $config = config::configReader::loadConfig('.env');

my $ua      = LWP::UserAgent->new();

sub message_send {
    my $url = 'https://api.vk.com/method/messages.send';
    my $send = [];
    if (!defined $_[2]) {
        $send = [
                'access_token' => $config->{'VKTOKEN'},
                'v' => '5.92',
                'peer_id' => $_[0],
                'random_id' => int(rand()),
                'message' => $_[1]
        ];
    } else {
        $send = [
                'access_token' => $config->{'VKTOKEN'},
                'v' => '5.92',
                'peer_id' => $_[0],
                'random_id' => int(rand()),
                'message' => $_[1],
                'attachment' => [$_[2]]
        ];
    };
    my $request = $ua->post( $url, $send);
    my $response = $request->as_string();
    #warn ($response);
}
sub message_sticker_send {
    my $url = 'https://api.vk.com/method/messages.send';
    my $send = [
            'access_token' => $config->{'VKTOKEN'},
            'v' => '5.92',
            'peer_id' => $_[0],
            'random_id' => int(rand()),
            'sticker_id' => $_[1]
    ];
    my $request = $ua->post( $url, $send);
    my $response = $request->as_string();
    #warn ($response);
}
my $wprotect = 0;
sub wall_get{
    my $clid = splice(@_, rand @_, 1);
    my $url = 'https://api.vk.com/method/wall.get';
    my $offset = int(rand(10000));
    my $send = [
            'access_token' => $config->{'GLEB'},
            'v' => '5.92',
            'count' => 1,
            'offset' => $offset,
            'owner_id' => $clid
    ];
    my $request = $ua->post( $url, $send);
    my $response = $request->decoded_content;
    warn(Dumper($response));
    my $json = decode_json($response);
    my $link;

    $wprotect = $wprotect + 1;
    if ($wprotect >= 3) { return 'video-79153897_456239331' };
    if (!defined $json->{'response'}->{'items'}->[0]) { $link = wall_get(@_); return $link };
    $link = 'wall'.$json->{'response'}->{'items'}->[0]->{'from_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    return $link;
}

sub photo_get_random {
    my $url = 'https://api.vk.com/method/photos.get';
    my $offset = int(rand(221));
    my $send = [
            'access_token' => $config->{'GLEB'},
            'v' => '5.92',
            'count' => 1,
            'offset' => $offset,
            'owner_id' => $_[0],
            'album_id' => $_[1]
    ];
    my $request = $ua->post( $url, $send);
    my $response = $request->decoded_content;
    my $json = decode_json($response);
    my $link = 'photo'.$json->{'response'}->{'items'}->[0]->{'owner_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    my $text = $json->{'response'}->{'items'}->[0]->{'text'};
    my @photo = ();
    push @photo, $link;
    push @photo, $text;
    return @photo;
}

my $vprotect = 0;
sub video_get_random {
    my $clid = splice(@_, rand @_, 1);
    my $url = 'https://api.vk.com/method/video.get';
    my $offset = int(rand(9999));
    my $send = [
            'access_token' => $config->{'GLEB'},
            'v' => '5.69',
            'count' => 1,
            'offset' => $offset,
            'owner_id' => $clid,
    ];
    my $request = $ua->post( $url, $send);
    my $response = $request->decoded_content;
    warn(Dumper($response));
    my $json = decode_json($response);
    my $link;
    $vprotect = $vprotect + 1;
    if ($vprotect >= 3) { return 'video-79153897_456239331' };
    if (!defined $json->{'response'}->{'items'}->[0]) { $link = video_get_random(@_); return $link };
    $link = 'video'.$json->{'response'}->{'items'}->[0]->{'owner_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    return $link;
}
1;
