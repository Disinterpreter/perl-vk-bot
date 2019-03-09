package config::configReader;
use warnings;
use strict;
use Data::Dumper;

sub loadConfig {

    my $filename = shift;
    open my $handle, '<', $filename;

    my $config = {};
    while (my $row = <$handle>) {
        if ($row =~ m/^(\w+)=(.+)$/gm) {
            $2 =~ s/\n//gm;
            $config->{$1} = $2;
        }
    }

    return $config;
}

#loadConfig('.env');
1;