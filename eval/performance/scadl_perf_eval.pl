#!/bin/env perl

#
# Descryption : This script is used to testing performance of typical ciphers(AES,DES,RC4)
# implementations of cryptol, mbedTLS and SCADL
#
# Author: jlrao <ary.xsnow@gmail.com>
# Date: Wed Oct 14 02:33:13 PDT 2015
# Copyright: Free use for edcuation/research
#

use strict;
use warnings;
use Cwd;
use Cwd qw(realpath);
use Getopt::Long;

my ($o_help, $o_tests_bits);
my ($opt_res) = GetOptions(
	                        "help|h"          =>\$o_help,
							"tests_bits|tb=i" => \$o_tests_bits
						  );


if (defined $o_help) { &print_help(); exit(0);}
if (!defined $o_tests_bits) { $o_tests_bits = 256; }

&main();
exit(0);

#=== Sub-routines
sub dec2hexstr()
{
	my ($num, $bytes) = @_;
	my ($val, $chr, $i);
	my $hexstr = "0x";

	# FIXME: only use the lower 32bit number for shift
	#        upper bits will be always 0(32-bit linux Perl)
	for ($i=$bytes-1; $i>=4; $i--)
	{
		$hexstr .= "00";
	}
	for ($i=3; $i>=0; $i--)
	{
		$val = ($num >> (8*$i)) & 0xff;
		$chr = sprintf("%02X", $val);
		$hexstr .= $chr;
	}

	return $hexstr;
}

sub parse_time()
{
	my ($ciphers, $imp) = @_;
	my ($fname, $i);
	my $info = ["", "", "", ""]; #ciphers, real_time, user_time, sys_time 
	my ($real_time, $user_time, $sys_time);

	for ($i=0; $i<=$#$ciphers; $i++)
	{
		$fname = $ciphers->[$i] . "_" . $imp . ".log";

		$info->[0] .= uc($ciphers->[$i]) . "/";

		$real_time = `grep real $fname`;
		chomp($real_time);
		$real_time =~ s/.*\s+(.*)$/$1/g;
		$info->[1] .= $real_time . "/";

		$user_time = `grep user $fname`;
		chomp($user_time);
		$user_time =~ s/.*\s+(.*)$/$1/g;
		$info->[2] .= $user_time . "/";

		$sys_time = `grep sys $fname`;
		chomp($sys_time);
		$sys_time =~ s/.*\s+(.*)$/$1/g;
		$info->[3] .= $sys_time . "/";
	}

	# remove tail /
	$info->[0] =~ s/\/$//g;
	$info->[1] =~ s/\/$//g;
	$info->[2] =~ s/\/$//g;
	$info->[3] =~ s/\/$//g;

	return $info;
}

sub main()
{
	my ($cpu_t, $usr_t, $sys_t);
	my $info;

	# clean
	system("make clean");

	print "INFO: evaluate DES/AES/RC4 on cryptol....\n";
	&cryptol_perf_eval();
	$info = &parse_time(["DES","AES","RC4"], "cryptol");
	print "ciphers          : $info->[0]\n";
	print "total data(bits) : $o_tests_bits\n";
	print "Real time        : $info->[1]\n";
	print "User time        : $info->[2]\n";
	print "Sys  time        : $info->[3]\n";

	print "\nINFO: evaluate DES/AES/RC4 on scadl....\n";
    &scadl_perf_eval();
	$info = &parse_time(["DES","AES","RC4"], "cadl");
	print "ciphers          : $info->[0]\n";
	print "total data(bits) : $o_tests_bits\n";
	print "Real time        : $info->[1]\n";
	print "User time        : $info->[2]\n";
	print "Sys  time        : $info->[3]\n";

	print "\nINFO: evaluate DES/AES/RC4 on mbedtls....\n";
	&mbedtls_perf_eval();
	$info = &parse_time(["DES","AES","RC4"], "mbedtls");
	print "ciphers          : $info->[0]\n";
	print "total data(bits) : $o_tests_bits\n";
	print "Real time        : $info->[1]\n";
	print "User time        : $info->[2]\n";
	print "Sys  time        : $info->[3]\n";
}

sub cryptol_perf_eval()
{
    my ($cipher, $fname, $fid, $ctx);
	my ($init_val, $end_val, $repeat_times);

	# DES.r
	$repeat_times = $o_tests_bits / 64;
	$cipher = "DES";
	$fname = $cipher . ".r";
	open($fid, ">$fname") or die $!;
	$ctx = ":l $cipher.cry\n";
	$init_val = &dec2hexstr(0, 8);
	$end_val   = &dec2hexstr($repeat_times-1, 8);
	$ctx .= "[[des_enc_single (k,pt)|k<-[$init_val..$end_val]] | pt<-[$init_val..$end_val]]\n";
	#$ctx .= "[[des_enc_single (k,pt)|k<-[0x1010101010101010]] | pt<-[1..$o_tests_bits]]\n";
	print $fid $ctx;
	close($fid);
	system("(time cryptol -b $fname) > ${cipher}_cryptol.log 2>&1");

	# AES.r
	$repeat_times = $o_tests_bits / 128;
	$cipher = "AES";
	$fname = $cipher . ".r";
	open($fid, ">$fname") or die $!;
	$ctx = ":l $cipher.cry\n";
	$init_val = &dec2hexstr(0, 16);
	$end_val   = &dec2hexstr($repeat_times-1, 16);
	$ctx .= "[[aesEncrypt (pt, k) | k<-[$init_val..$end_val]] | pt<-[$init_val..$end_val]]\n";
	#$ctx .= "[[aesEncrypt (pt, k) | k<-[0x01010101010101010101010101010101]] | pt<-[1..$o_tests_bits]]\n";
	print $fid $ctx;
	close($fid);
	system("(time cryptol -b $fname) > ${cipher}_cryptol.log 2>&1");

	# RC4.r
	$repeat_times = $o_tests_bits / 256;
	$cipher = "RC4";
	$fname = $cipher . ".r";
	open($fid, ">$fname") or die $!;
	$ctx = ":l $cipher.cry\n";
	$init_val = &dec2hexstr(0, 8);
	$end_val   = &dec2hexstr($repeat_times-1, 8);
	$ctx .= "[ks [b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15] | b0<-[$init_val..$end_val] | b1<-[$init_val..$end_val]| b2<-[$init_val..$end_val]| b3<-[$init_val..$end_val]| b4<-[$init_val..$end_val]| b5<-[$init_val..$end_val]| b6<-[$init_val..$end_val]| b7<-[$init_val..$end_val]| b8<-[$init_val..$end_val]| b9<-[$init_val..$end_val]| b10<-[$init_val..$end_val]| b11<-[$init_val..$end_val]| b12<-[$init_val..$end_val]| b13<-[$init_val..$end_val]| b14<-[$init_val..$end_val]| b15<-[$init_val..$end_val]]\n";
	#$ctx .= "[ks [b0,b1,b2,b3] | b0<-[1..$o_tests_bits] | b1<-[1..$o_tests_bits] | b2<-[1..$o_tests_bits] | b3<-[1..$o_tests_bits]]\n";
	print $fid $ctx;
	close($fid);
	system("(time cryptol -b $fname) > ${cipher}_cryptol.log 2>&1");
}

sub mbedtls_perf_eval()
{
    my ($cipher, $repeat_times);

	# build
	system("make mbedtls");

	# DES
	$cipher = "DES";
	$repeat_times = $o_tests_bits / 64;
	system("(time ./${cipher}_mbedtls $repeat_times) > ${cipher}_mbedtls.log 2>&1");

	# AES
	$cipher = "AES";
	$repeat_times = $o_tests_bits / 128;
	system("(time ./${cipher}_mbedtls $repeat_times) > ${cipher}_mbedtls.log 2>&1");

	# RC4
	$cipher = "RC4";
	$repeat_times = $o_tests_bits / 256;
	system("(time ./${cipher}_mbedtls $repeat_times) > ${cipher}_mbedtls.log 2>&1");
}

sub scadl_perf_eval()
{
    my ($cipher, $repeat_times);

	# DES_perf.cad
	$cipher = "DES";
	$repeat_times = $o_tests_bits / 64;
	system("sed 's/PARAM_TEST_TIMES/$repeat_times/g' ${cipher}_perf.cad > ${cipher}_perf_patched.cad");
	system("cp -f ${cipher}_perf_patched.cad CADL.input");
	system("make build");
	system("(time ./cadlTest) > ${cipher}_cadl.log 2>& 1");

	# AES_perf.cad
	$cipher = "AES";
	$repeat_times = $o_tests_bits / 128;
	system("sed 's/PARAM_TEST_TIMES/$repeat_times/g' ${cipher}_perf.cad > ${cipher}_perf_patched.cad");
	system("cp -f ${cipher}_perf_patched.cad CADL.input");
	system("make build");
	system("(time ./cadlTest) > ${cipher}_cadl.log 2>& 1");

	# RC4_perf.cad
	$cipher = "RC4";
	$repeat_times = $o_tests_bits / 256;
	system("sed 's/PARAM_TEST_TIMES/$repeat_times/g' ${cipher}_perf.cad > ${cipher}_perf_patched.cad");
	system("cp -f ${cipher}_perf_patched.cad CADL.input");
	system("make build");
	system("(time ./cadlTest) > ${cipher}_cadl.log 2>& 1");
}
