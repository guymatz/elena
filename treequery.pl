#!/usr/bin/env perl

$data_file = "data.csv";
@nyc_trees = [];

open($fh, $data_file) or die "Could not open file $data_file: $!";
while($line = <$fh>) {
    %tree = {};
    chomp $line;
    @tree_data = split(/,/, $line);
    $tree{'tree_id'} = $tree_data[0];
    $tree{'tree_dbh'} = $tree_data[1];
    $tree{'health'} = $tree_data[2];
    $tree{'pc_common'} = $tree_data[3];
    $tree{'zipcode'} = $tree_data[4];
    $tree{'boroname'} = $tree_data[5];
    $tree{'nta_name'} = $tree_data[6];
    $latitude = $tree_data[7];
    $longitude = $tree_data[8];
    %gps_coordinates = (
                        "latitude", $latitude,
                        "longitude", $longitude
                    );
    $tree{'gps_coordinates'} = \%gps_coordinates;
    print "$tree{'tree_id'}, $tree{'pc_common'}\n";
    push @nyc_trees, %tree;
}
