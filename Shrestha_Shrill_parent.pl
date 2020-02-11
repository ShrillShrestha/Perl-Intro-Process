#! /usr/bin/perl 

# Name: Shrill Shrestha
# Course: Operating System
# Due Date: Feb 13, 2020
# This program reads an input file and create child process to exec assigned file to deliver an output.

# import modules 
use strict;
use warnings;

# declear and initializing variables
my $inFileName = "in.txt";
my $outFileName = "out.txt";
my @childNums;
my @childFiles;
my $loopVar = 0;
my $fh;
my @outarray;

unlink ("out.txt");  # delete out.txt if exist to prevent overwrite

# open in.txt file to read
if(!(open ($fh, '<:encoding(UTF-8)', $inFileName))){
    finalFileOpen($outFileName, "Can't access 'in.txt'.", 1);
    exit;
}

# read lines from the file
while(my $line = <$fh>){
    chomp $line;
    if($loopVar == 0){
        @childNums = split(" ", $line);  # record number of child
        $loopVar++;
    }else{
        @childFiles = split(" ", $line);  # record text files to be read
    }
}
close($fh);

# child process creation and exec files
for(my $i = 0; $i < $childNums[1]; $i++){
    my $pid = fork();

    if($pid == 0){
        my $file = $childFiles[$i + 1];
        exec("./Shrestha_Shrill_child.pl --file $file --cid $i");
    }
} 

# wait for child process to end
for(my $j = 0; $j < $childNums[1]; $j++){
    my $child = wait();
}

#-----------------------------------------

my $ah;
my $oFile = "";
my $lcnt = 0;  # number of lines in a file
my $tLines = 0;  # total number of lines

# read available genrated out files and store in an array
for(my $k = 0; $k < $childNums[1]; $k++){
    $oFile = "out".$k.".txt";  # filename creation
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

# store lines in out finalOut var formatted
while ($cnt < $tLines){
    for(my $l = 0; $l < $childNums[1]; $l++){
        if($outarray[$l][$col]){
            $finalOut = $finalOut.$outarray[$l][$col]."\n";
            $cnt++;
        }
    }
    $col++;
}

# print in out file
finalFileOpen($outFileName, $finalOut, 0);

sub finalFileOpen {
    my $fileN = $_[0];
    my $breakPos = $_[2];
    my $msg = $_[1];
    if(open($fh, '>>', $fileN )){
        print $fh $msg;
        close($fh);
    }else{
        if($breakPos == 1){
            die "Can't open the file '$fileN' and $msg $!"
        }else{
            die "Can't open the file '$fileN' $!";
        }
    }
}