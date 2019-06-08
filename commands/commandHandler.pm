package commands::commandHandler;
use Data::Dumper;
use utf8;

my %allcommands;

# createCommand(str name, func handl);
sub createCommand($$) {
    $allcommands->{$_[0]} = $_[1];
    #print(Dumper(@_));
};

# execCommand(VK Array, determinator);
sub execCommand {
    my $arr = $_[0];
    my $determinator = $_[1];
    if (defined $allcommands->{$determinator}) {
        $allcommands->{$determinator}($arr);
    }
};
1;
