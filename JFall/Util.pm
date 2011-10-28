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

sub nextStage {
	return adjacentStage(sub{$_[0] + 1}, shift @_);
}

sub previousBranch {
	return adjacentBranch(\&previousStage, shift @_);
}

sub previousStage {
	return adjacentStage(sub{$_[0] - 1}, shift @_);
}

sub adjacentBranch {
	my $adjacentStage = shift @_;
	my $adjacentBranch = shift @_;
	if ($adjacentBranch =~ m/(.+)(-)(\d+)/) {
		my $branchName = $1;
		my $separator = $2;
		my $stage = $3;
		$adjacentBranch = $branchName . $separator . $adjacentStage->($stage);
	}
	return $adjacentBranch;
}

sub adjacentStage {
	my $operator = shift @_;
	my $stage = shift @_;
	my $adjacentStage = $operator->(scalar($stage));
	
	if ($adjacentStage < 10) {
		return "0$adjacentStage";
	} else {
		return "$adjacentStage";
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
