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
            my $key = $1;
            my $param = $2;
            $param =~ s/\s+//g;
            $config->{$key} = $param;
        }
    }
    return $config;
}

#loadConfig('.env');
1;