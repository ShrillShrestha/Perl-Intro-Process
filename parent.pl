#! /usr/bin/perl

use strict;
use warnings;

my $inFileName = "in.txt";
my $outFileName = "out.txt";
my @childNums;
my @childFiles;
my $loopVar = 0;
my $fh;
my @outarray;

open ($fh, '<:encoding(UTF-8)', $inFileName)
    or die "Couldn't open the file '$inFileName' $!";

while(my $line = <$fh>){
    chomp $line;
    if($loopVar == 0){
        @childNums = split(" ", $line);
        $loopVar++;
    }else{
        @childFiles = split(" ", $line);
    }
}
close($fh);

for(my $i = 0; $i < $childNums[1]; $i++){
    my $pid = fork();

    if($pid == 0){
        my $file = $childFiles[$i + 1];
        exec("./child.pl --file $file --cid $i");
    }
} 

for(my $j = 0; $j < $childNums[1]; $j++){
    my $child = wait();
}

#-----------------------------------------

my $ah;
my $oFile = "";
my $lcnt = 0;
my $tLines = 0;

for(my $k = 0; $k < $childNums[1]; $k++){
    $oFile = "out".$k.".txt";
    if(open ($ah, '<:encoding(UTF-8)', $oFile)){
        while(my $line = <$ah>){
            chomp $line;
            $outarray[$k][$lcnt] = $line;
            $lcnt++;
        }
        $tLines += $lcnt; 
        $lcnt = 0;
    }else{
        $outarray[$k][0] = "Couldn't access the file '$oFile' $!.!";
        $tLines += 1;
    }
}

my $finalOut = "";
my $cnt = 0;
my $col = 0;

while ($cnt < $tLines){
    for(my $l = 0; $l < $childNums[1]; $l++){
        if($outarray[$l][$col]){
            $finalOut = $finalOut.$outarray[$l][$col]."\n";
            $cnt++;
        }
    }
    $col++;
}

if(open($fh, '>>', $outFileName)){
    print $fh $finalOut;
    close($fh);
}else{
    die "Couldn't open the file '$outFileName' $!";
}