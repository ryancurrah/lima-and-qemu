#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw();

my $proc = qx(uname -p);
my $arch = $proc =~ /86/ ? "x86_64" : "aarch64";
my $codename = $ARGV[0];

# This script creates a tarball containing limactl from /usr/local/limactl.
my $install_dir = $arch eq "x86_64" ? "/usr/local" : "/opt/homebrew";

my $dist = "limactl";
system("rm -rf /tmp/$dist");

# Copy limactl to /tmp tree
my $file = "$install_dir/bin/limactl";
my $copy = $file =~ s|^$install_dir|/tmp/$dist|r;
system("mkdir -p " . dirname($copy));
system("cp $file $copy.$codename");

# Ensure all files are writable by the owner; this is required for Squirrel.Mac
# to remove the quarantine xattr when applying updates.
system("chmod -R u+w /tmp/$dist");

my $repo_root = join('/', dirname($FindBin::Bin), 'src', 'lima');
unlink("$repo_root/$dist.tar.gz");
system("tar cvfz $repo_root/$dist.tar.gz -C /tmp/$dist bin/limactl.$codename");

exit;

sub dirname {
    shift =~ s|/[^/]+$||r;
}
