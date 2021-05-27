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
use feature "switch";
use IPC::Run 'run';
use HTML::TreeBuilder::XPath;

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

my @varlamov = (
    -178831229
);
sub varlamov {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@varlamov);
    requests::sender::message_send($peer_id,'', $post);
    #warn(Dumper($jconf->{'response'}->{'items'}->[0]->{'id'}))

}

my @tyan = (
    -79458616,
    -132807795,
    -121581173,
    -54709527,
    -130914885,
    -111044288,
    -102853758,
    -134982584
    
);
sub tyan {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@tyan);
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
        'audio371745451_456569171',
	'audio61580061_456239547'

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

sub hime {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id,'', 'video475072121_456239025');
}

sub bio {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id,'', 'video-55093819_456240747');
}

sub russia {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id,'', 'video-60112307_456241895');
}

my @twit = (
	-140336241
);

sub twit {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@twit);
    requests::sender::message_send($peer_id,'', $post);
}

sub avx {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id,'', 'video218534351_456239232');
}

sub horoscope {
    my @horoscope = (
        -170116567,
        -176101512
    );
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $post = requests::sender::wall_get(@horoscope);
    requests::sender::message_send($peer_id,'', $post);
};

sub eightball {
    my @eanswers = (
        'Бесспорно',
        'Предрешено',
        'Никаких сомнений',
        'Определённо да',
        'Можешь быть уверен в этом',
        'Мне кажется — «да»',
        'Вероятнее всего',
        'Хорошие перспективы',
        'Знаки говорят — «да»',
        'Да',

        'Пока не ясно, попробуй снова',
        'Спроси позже',
        'Лучше не рассказывать',
        'Сейчас нельзя предсказать',
        'Сконцентрируйся и спроси опять',

        'Даже не думай',
        'Мой ответ — «нет»',
        'По моим данным — «нет»',
        'Перспективы не очень хорошие',
        'Весьма сомнительно'      
    );

    my $decidion = int(rand(scalar(@eanswers)));

    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id, $eanswers[$decidion]);
};

sub krober {
    my $ua       = LWP::UserAgent->new();

    my $response = $ua->get( 'https://krober.biz/?p=2441' );
    my $content  = $response->decoded_content();


    my $peer_id = $_[0]->{'object'}->{'peer_id'};

    if ($content =~ m/.+<\/a>\s+(.+)\s+\s+\s+<\/div><!-- #site-info -->/gm) {
        requests::sender::message_send($peer_id, $1);
    } else {
        requests::sender::message_send($peer_id, 'кроба упал');
    }
}

sub doing {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    warn($message);

    my $cinfo = requests::sender::getConversationMembers($peer_id);
    my $profilesCount = $cinfo->{'response'}->{'count'};
    my $profilesArray = $cinfo->{'response'}->{'profiles'};
    my $profil = rand(int($profilesCount));
    my $randlastname = $profilesArray->[$profil]->{'last_name'} || $profilesArray->[0]->{'last_name'};
    my $randfirsttname = $profilesArray->[$profil]->{'first_name'} || $profilesArray->[0]->{'first_name'};
    my $na = $randfirsttname . " " . $randlastname;

    my $profil2 = rand(int($profilesCount));
    my $randlastname2 = $profilesArray->[$profil2]->{'last_name'} || $profilesArray->[0]->{'last_name'};
    my $randfirsttname2 = $profilesArray->[$profil2]->{'first_name'} || $profilesArray->[0]->{'first_name'};
    my $na2 = $randfirsttname2 . " " . $randlastname2;

    #my $tetmsg = $message
    $message =~ s/^https?:\/\/(?:www\.)?([^\/.]+)\.([^\/.]+).*//i;
    my $count100 = int(rand(100));
    $message =~ s/(%u\b)/$na/g;
    $message =~ s/(%u2)/$na2/g;
    $message =~ s/(%d)/$count100/g;
    requests::sender::message_send($peer_id, "Ответ: " . $message);
}

sub crypto {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    # Тут нам помешал CloudFlare, но почему-то через curl пустил
    # небохато жили неча и начинать
    my $currency = `curl -s --location --request GET "api.coincap.io/v2/assets?limit=20"`;
    # my $ua      = LWP::UserAgent->new();
    # my $url = 'https://api.coincap.io/v2/assets?limit=20';
    # my $request = $ua->get( $url );
    # my $response = $request->decoded_content;
    #print(Dumper($response));
    my $cryptocurrensy = JSON::XS->new->ascii->pretty->allow_nonref;
    my $jstring = $cryptocurrensy->decode($currency);
    
    #warn ($message);
    if (length($message) == 13 || length($message) == 11) {
        my $carray = $jstring->{'data'};
        my @costarr = ();
        foreach my $cr (@$carray) {
            if ($cr->{'changePercent24Hr'} >= 0) {
                my $cnp = $cr->{'symbol'}." ".sprintf("%.2f", $cr->{'priceUsd'}). " ⬆ на: ". sprintf("%.2f", $cr->{'changePercent24Hr'}) ."%";
                push @costarr, $cnp;
            } else {
                my $cnp = $cr->{'symbol'}." ".sprintf("%.2f", $cr->{'priceUsd'}). " ⬇ на: ". sprintf("%.2f", $cr->{'changePercent24Hr'}) . "%";
                push @costarr, $cnp;
            }

        }
        my $total = join("<br>",@costarr);
        
        requests::sender::message_send($peer_id, "Курс всех популярных валют:<br>".$total."\n");
    }
    for($message) {
        when ("биток") {
            requests::sender::message_send($peer_id, "Биток сейчас стоит \$".$jstring->{'data'}->[0]->{priceUsd}."\n");
        }
        when ("эфир") {
            requests::sender::message_send($peer_id, "Биток сейчас стоит \$".$jstring->{'data'}->[1]->{priceUsd}."\n");
        }
    };
    # switch($message) {
    #     case "биток" {
    #         print(Dumper($response->{'data'}->[0]->{priceUsd}));
    #     }
    # }
    
}

sub weather{
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    my $ua      = LWP::UserAgent->new();
    my $url = "https://api.openweathermap.org/data/2.5/weather?q=".$message.",ru&units=metric&appid=".$config->{'WEATHER'} ;
    my $request = $ua->get( $url );
    my $weather = $request->decoded_content;

    my $initjson = JSON::XS->new->ascii->pretty->allow_nonref;
    my $jstring = $initjson->decode($weather);
    if ($jstring->{'cod'} eq '200') {
        requests::sender::message_send($peer_id, "Погода в ".$message." сейчас:<br>".$jstring->{'main'}->{'temp'}."\n"); 
    } else {
        requests::sender::message_send($peer_id, "Неправильно указан город.\n"); 
    }
    
};

sub executejs {
    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    my $message = $_[0]->{'object'}->{'text'};
    $message =~ s/^\w+\s+\w+\s+//g;
    #warn($message);

    #run ["firejail" ,"jslaunch", "--rlimit-as=1","--noprofile", $message ], "&>", \my $stdout;
    run ["firejail", "--noprofile", "--quiet", "timeout", "8s" ,"jslaunch", $message ], "&>", \my $stdout;
    my @values = split('\n', $stdout);

    #$stdout =~ s/\*\*.+//gmu;
    #warn($stdout);

    #my $out = join('<br>', @values);
    if (scalar(@values) >= 25) {
        requests::sender::message_send($peer_id, "Ответ: слишком большой вывод.");
        return;
    }
    warn(Dumper(@values) );
    requests::sender::message_send($peer_id, "Ответ: " . $stdout);
};

sub ksas {
	my $peer_id = $_[0]->{'object'}->{'peer_id'};
	my $message = $_[0]->{'object'}->{'text'};
	$message =~ s/^\w+\s+\w+\s+//g;	

	my @ksas_mems = (
		-187587341
	);
    my $post = requests::sender::wall_get(@ksas_mems);
    requests::sender::message_send($peer_id,'', $post);
};

sub reforged {
	my $peer_id = $_[0]->{'object'}->{'peer_id'};
	my $message = $_[0]->{'object'}->{'text'};
	$message =~ s/^\w+\s+\w+\s+//g;	
    my $browser = LWP::UserAgent->new;
    my $tree= HTML::TreeBuilder::XPath->new;

    my $response = $browser->get( 'https://www.metacritic.com/game/pc/warcraft-iii-reforged' );

    my $content = $response->content;
    $tree->parse_content($content);

    my @subj = $tree->findvalues('//*[@class="metascore_w user large game negative"]');

    my @opinion = $tree->findvalues('//*[@class="blurb blurb_expanded"]');
    my $msg = "Ваш рефордж: ". $subj[0] . "<br>Мнение:<br>". @opinion[scalar(rand(int(@opinion)))];
    requests::sender::message_send($peer_id,$msg);
};

sub party {
    my @aparty = (
        'Ты вступил в партию "Любителей пива"',
        'Ты вступил в партию "Пидорасов"',
        'Ты вступил в "ЛДПР"',
        'Ты вступил в "Единную Россию"',
        'Ты вступил в "КПРФ"',
        'Ты вступил в "Яблоко"',
        'Ты вступил "В Справедливую Россию"',
        'Ты вступил "В Говно"',
        'Ты вступил "В Парнас"'   
    );

    my $decidion = int(rand(scalar(@aparty)));

    my $peer_id = $_[0]->{'object'}->{'peer_id'};
    requests::sender::message_send($peer_id, $aparty[$decidion]);
};

commands::commandHandler::createCommand("рефордж", \&reforged);
commands::commandHandler::createCommand("жс", \&executejs);
commands::commandHandler::createCommand("погода", \&weather);
commands::commandHandler::createCommand("курс", \&crypto);
commands::commandHandler::createCommand("крипта", \&crypto);
commands::commandHandler::createCommand("действие", \&doing);
commands::commandHandler::createCommand("шар", \&eightball);
commands::commandHandler::createCommand("гороскоп", \&horoscope);
commands::commandHandler::createCommand("химе", \&hime);
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
commands::commandHandler::createCommand("биография", \&bio);
commands::commandHandler::createCommand("многоэтажка", \&varlamov);
commands::commandHandler::createCommand("твит", \&twit);
commands::commandHandler::createCommand("avx", \&avx);
commands::commandHandler::createCommand("тяночку", \&tyan);
commands::commandHandler::createCommand("кроба", \&krober);
commands::commandHandler::createCommand("ксас", \&ksas);
commands::commandHandler::createCommand("вступить_в_партию", \&party);
commands::commandHandler::createCommand("Россия", \&russia);
1;
