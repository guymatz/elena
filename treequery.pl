#!/usr/bin/env perl

use strict;
use feature "say";
use Data::Dumper;

my $argument = @ARGV;
my $treefile =$ARGV[0];

if ($argument != 1) {
        die "USAGE: Input .csv file" ; #"USAGE: Input.csv file"
}
my @nyc_trees = ();

open(my $fh, $treefile) or die "Could not open file $treefile: $!";
while(my $line = <$fh>) {
    my %tree = ();
    chomp $line;
    my @tree_data = split(/,/, $line);
    $tree{'tree_id'} = $tree_data[0];
    $tree{'tree_dbh'} = $tree_data[1];
    $tree{'health'} = $tree_data[2];
    $tree{'pc_common'} = $tree_data[3];
    $tree{'zipcode'} = $tree_data[4];
    $tree{'boroname'} = $tree_data[5];
    $tree{'nta_name'} = $tree_data[6];
    my $latitude = $tree_data[7];
    my $longitude = $tree_data[8];
    my %gps_coordinates = (
                        "latitude", $latitude,
                        "longitude", $longitude
                    );
    $tree{'gps_coordinates'} = \%gps_coordinates;
    #print "$tree{'tree_id'}, $tree{'pc_common'}, $tree{'zipcode'}, \n";
    push @nyc_trees, \%tree;
}

sub number_of_trees {
    my $tree_type = shift;
    my $tree_ctr = 0;
    foreach my $tree_ref (@nyc_trees) {
        if (${$tree_ref}{pc_common} eq $tree_type) {
            $tree_ctr++;
        }
    }
    return $tree_ctr;
}

sub zip_of_trees {
    my $tree_type = shift;
    my %zips = ();
    foreach my $tree_ref (@nyc_trees) {
        if (${$tree_ref}{pc_common} eq $tree_type) {
            #say " I see ${$tree_ref}{zipcode}";
            $zips{${$tree_ref}{zipcode}}++;
        }
    }
    my @uniq_zips = sort(keys %zips);
    return join(", ", @uniq_zips);
}

sub avg_diam {
    my $tree_type = shift;
    my @treediameters = ();
    foreach my $tree_ref (@nyc_trees) {
        if (${$tree_ref}{pc_common} eq $tree_type) {
            #say " I see ${$tree_ref}{zipcode}";
            push(@treediameters, ${$tree_ref}{tree_dbh}); 
        }
    }
    my $totaldiameter = 0;
    foreach my $tree_diam (@treediameters) {
        $totaldiameter = $totaldiameter + $tree_diam;
    }
    my $average = $totaldiameter / (scalar @treediameters);
    return $average;
}

while (1) {
    print 'Enter the name of a type of tree, or enter "quit" to quit: ';
    my $input = <STDIN>;
    chomp $input;
    if ($input eq "quit") {
        exit;
    }
    else {
        my $tree_type = $input;
        my $number_of_trees = &number_of_trees($tree_type);
        if ($number_of_trees > 0) {
            my $zip_of_trees = &zip_of_trees($tree_type);
            my $avg_diameter_of_trees = &avg_diam($tree_type);
            say "total number of such trees: ", $number_of_trees; 
            say "zip codes in which this tree is found: ", $zip_of_trees;
            say "average diameter: ", $avg_diameter_of_trees;
        }
        else {
            say "I found no trees called $tree_type";
        }
    }
}
