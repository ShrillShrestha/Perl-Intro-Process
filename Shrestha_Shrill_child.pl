#! /usr/bin/perl

# Name: Shrill Shrestha
# Course: Operating System
# Due Date: Feb 13, 2020
# This program is a child process to exec assigned file to deliver an output.

# importing modules 
use strict;
use warnings;
use Getopt::Long 'HelpMessage';

my $fileName = "";
my $cid = "";
my $output = "";
my $err = 0;

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
# read the files
if(open ($fh, '<:encoding(UTF-8)', $fileName)){
    my $counter = 1;
    while(my $line = <$fh>){
        chomp $line;
        $output = "$output"."Child[$cid]: Line[$counter]: "."$line\n";
        $counter++;
    }
    close($fh);
    chomp $output;   
}else{  # exception handel
    if(open($fh, '>', $outFile)){  # child can't access child's infile
        print $fh "Child[$cid]: Can't access '$fileName'. This file won't be considered.\n";
        exit;
    }else{
        if(open $fh, '>>', "out.txt"){ # child can't access child's infile and outfile
            print $fh "Child[$cid]: Note: Couldn't access '$fileName', '$outFile'. These files won't be considered.\n\n";
            exit;
        }else{  # child can't access infile, outfile and final outfile
            die "Couldn't access '$fileName', '$outFile' and out.txt";
        }
    }
}

# print in respective outfile
if(open($fh, '>', $outFile)){
    print $fh $output;
    close($fh); 
}else{  # exception handel: no access to child's outfile
    if(open $fh, '>>', "out.txt"){
            print $fh "Child[$cid]: Couldn't access '$outFile'. This file won't be considered.\n\n";
    }else{  # no access to outfile and final outfile
        die "Couldn't access '$outFile' and out.txt";
    }
}