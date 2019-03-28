package requests::sender;

use LWP;
use LWP::UserAgent; 
use LWP::Simple qw(getstore);

use lib '../';
use config::configReader;
use warnings;
use strict;
use JSON;
use Data::Dumper;
use utf8;

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
    
    if (!defined $json->{'response'}->{'items'}->[0]) { 
            my $maxcount = $json->{'response'}->{'count'};
            my $send2 = [
            'access_token' => $config->{'GLEB'},
            'v' => '5.92',
            'count' => 1,
            'offset' => int(rand($maxcount)),
            'owner_id' => $clid
            ];
            warn (Dumper($maxcount));
            warn (Dumper($send2));
            my $secrequest = $ua->post( $url, $send2);
            my $secresponse = $secrequest->decoded_content;
            my $json2 = decode_json($secresponse);
            warn (Dumper($json));
            $link = 'wall'.$json2->{'response'}->{'items'}->[0]->{'from_id'}."_".$json2->{'response'}->{'items'}->[0]->{'id'};
            return $link;
    };
    $link = 'wall'.$json->{'response'}->{'items'}->[0]->{'from_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    return $link;
}

sub photo_get_random {
    my $url = 'https://api.vk.com/method/photos.get';
    my $offset = int(rand(65535));
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
    my $link;
    if (!defined $json->{'response'}->{'items'}->[0]) { 
            my $maxcount = $json->{'response'}->{'count'};
            my $send2 = [
            'access_token' => $config->{'GLEB'},
            'v' => '5.92',
            'count' => 1,
            'offset' => int(rand($maxcount)),
            'owner_id' => $_[0],
            'album_id' => $_[1]
            ];
            my $secrequest = $ua->post( $url, $send2);
            my $secresponse = $secrequest->decoded_content;
            my $json2 = decode_json($secresponse);
            $link = 'photo'.$json2->{'response'}->{'items'}->[0]->{'owner_id'}."_".$json2->{'response'}->{'items'}->[0]->{'id'};
            my $text = $json2->{'response'}->{'items'}->[0]->{'text'};
            warn (Dumper($text));
            if ($text eq '') { $text = "<3" };
            my @photo = ();
            push @photo, $link;
            push @photo, $text;
            return @photo;
    };
    $link = 'photo'.$json->{'response'}->{'items'}->[0]->{'owner_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    
    my $text = $json->{'response'}->{'items'}->[0]->{'text'};
    if ($text eq '') { $text = "<3" };
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
    if ($vprotect >= 4) { $vprotect = 0; return 'video-79153897_456239331' };
    if (!defined $json->{'response'}->{'items'}->[0]) { $link = video_get_random(@_); return $link };
    $vprotect = 0;
    $link = 'video'.$json->{'response'}->{'items'}->[0]->{'owner_id'}."_".$json->{'response'}->{'items'}->[0]->{'id'};
    return $link;
}

sub upload_doc {
        my $link = shift;
        my $name = shift;
        my $peer_id = shift;
        my $response = $ua->get($link);
        my $filename = $link;
        $filename =~ m/.*\/(.*)$/;
        $filename = $1;
        die $response->status_line if !$response->is_success;
        my $file = $response->decoded_content( charset => 'none' );
        my $save = "/tmp/$filename";
        getstore($link,$save);
        my $uploadurl = getMessagesUploadServer($peer_id);
        my $req = $ua->post($uploadurl,
                Content_Type => 'form-data',
                Content => [
                'file' => [ $save ],
                ],
        );
        my $vkfileinfo = $req->decoded_content;
        my $json = decode_json($vkfileinfo);
        #warn(Dumper($json));
        my $saved = docs_save($json->{'file'}, $filename);
        my $doc = 'doc'.$saved->{'response'}->[0]->{'owner_id'}.'_'.$saved->{'response'}->[0]->{'id'};
        #message_send($peer_id, $name, ;
        warn(Dumper($saved));
        unlink($save);
        return $doc;
}

sub getMessagesUploadServer{
        my $peer_id = shift;
        my $url = 'https://api.vk.com/method/docs.getMessagesUploadServer';
        my $send = [
                'access_token' => $config->{'VKTOKEN'},
                'v' => '5.69',
                'peer_id' => $peer_id
        ];
        my $request = $ua->post( $url, $send);
        my $response = $request->decoded_content;
        my $json = decode_json($response);
        return $json->{'response'}->{'upload_url'}
}

sub docs_save {
        my $file = shift;
        my $name = shift;
        my $tag = "anime";
        my $url = 'https://api.vk.com/method/docs.save';
        my $send = [
                'access_token' => $config->{'VKTOKEN'},
                'v' => '5.69',
                'file' => $file,
                'name' => $name,
                'tags' => $tag
        ];
        my $request = $ua->post( $url, $send);
        my $response = $request->decoded_content;
        my $json = decode_json($response);
        return $json;
}
1;
