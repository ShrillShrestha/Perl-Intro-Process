#! /usr/bin/perl

use strict;
use warnings;
use Getopt::Long 'HelpMessage';

my $fileName = "";
my $cid = "";
my $output = "";

GetOptions(
    "file=s"=>\$fileName,
    "cid=s"=>\$cid,
    "help"=>sub{HelpMessage(0)}
)
or HelpMessage(1);

#---------- HelpMessage ----------
=head1 NAME
    getop = This program show how Getopt::Long can be used
=head1 SYNOPSIS
    --help, --h     displays help window
    --file          filename
=head1 VERSION
    1.0
=cut
#---------- HelpMessage ----------

my $outFile = "out".$cid.".txt";
my $fh;
open ($fh, '<:encoding(UTF-8)', $fileName)
    or die "Couldn't open the file '$fileName' $!";

my $counter = 1;
while(my $line = <$fh>){
    chomp $line;
    $output = "$output"."Child[$cid]: Line[$counter]: "."$line\n";
    $counter++;
}
close($fh);
chomp $output;

open($fh, '>', $outFile)
or die "Couldn't open the file '$outFile' $!";
print $fh $output;
close($fh);


