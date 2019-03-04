use strict;
use warnings;
use Data::Dumper;
use JSON;
use LWP;
use LWP::UserAgent; 
use utf8;
use lib './';
use lib './commands';
use lib './requests';
use commands::commandHandler;
use commands::hello;
use commands::ltools;
use commands::games;
use requests::sender;

use Plack::Request;


my $app = sub {
     my $env = shift;
     my $ua      = LWP::UserAgent->new();
     
     my $req = Plack::Request->new($env);
     my $content = $req->content();
     my $jstring = decode_json($content);
     if ($jstring->{'type'} eq 'message_new') {
          my $id = $jstring->{'object'}->{'id'};
          my $peer_id = $jstring->{'object'}->{'peer_id'};
          my $message = $jstring->{'object'}->{'text'};
          my $peer = $jstring->{'object'}->{'peer_id'};

          my @args = split ( " ", $message);
          if ($args[0] =~ m/(ко(с|)тян|rjcnzy)(,|)/gmui) {
            my $determinator = $args[1];
            commands::commandHandler::execCommand($jstring, $determinator);
          } else {
            return [
                    '200',
                    [ 'Content-Type' => 'text/html' ],
                    [ "ok" ],
            ];            
          }
    }
     return [
             '200',
             [ 'Content-Type' => 'text/html' ],
             [ "ok" ],
     ];
};