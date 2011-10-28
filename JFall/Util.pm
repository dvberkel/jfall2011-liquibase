package JFall::Util;

use strict;
use warnings;

require Exporter;

our $VERSION = '1.00';

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(checkout nextBranch previousBranch currentBranch);

sub checkout {
	my $branch = shift @_;
	system("git checkout $branch");
}

sub nextBranch {
	return adjacentBranch(\&nextStage, shift @_);
}

sub adjacentBranch {
	my $adjacentStage = shift @_;
	my $nextBranch = shift @_;
	if ($nextBranch =~ m/(.+)(-)(\d+)/) {
		my $branchName = $1;
		my $separator = $2;
		my $stage = $3;
		$nextBranch = $branchName . $separator . $adjacentStage->($stage);
	}
	return $nextBranch;
}

sub nextStage {
	my $stage = shift @_;
	my $nextStage = scalar($stage) + 1;
	
	if ($nextStage < 10) {
		return "0$nextStage";
	} else {
		return "$nextStage";
	}
}

sub previousBranch {
	return adjacentBranch(\&previousStage, shift @_);
}

sub previousStage {
	my $stage = shift @_;
	my $nextStage = scalar($stage) - 1;
	
	if ($nextStage < 10) {
		return "0$nextStage";
	} else {
		return "$nextStage";
	}
}

sub currentBranch {
	my $currentBranch = '';
	my @branches = split "\n", `git branch`;
	while (my $branch = shift @branches) {
		if ($branch =~ m/^\*\s+(\S+)/) {
			$currentBranch = $1;
			last;
		}
	}
	
	return $currentBranch;
}
