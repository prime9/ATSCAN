#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
## Copy@right Alisam Technology see License.txt

our ($browserLang, $mrand, $motorparam, $motor, $motor1, $motor2, $motor3, $motor4, $motor5, $motor6, $motor7, $mrandom, $googleDomain, $prandom, $proxy, $mlevel, $ifinurl, $unique, $mdom, 
     $searchRegex, $Target, $dork, $ua, $Id, $MsId, $V_SEARCH,$nolisting, $mindex, $headers, $zone, $agent, $exclude, $expHost, $mupload,
     $expIp, $popup, $JoomSites, $WpSites, $fullHeaders, $geoloc, $apikey, $cx, $shodan, $bugtraq);
our (@motor, @TODO, @V_TODO, @c, @TT, @DS, @DT, @dorks, @SCAN_TITLE, @motors, @mrands, @aTsearch, @proxies, @commands, @V_INPUT);
our ($limit, $post, $get, $replace, $output, $data, $noQuery, $V_IP, $replaceFROM, $eMails, $searchIps, $brandom, $validShell, 
     $noverbose, $timeout, $method, $command, $freq, $ipUrl, $exploit, $p, $shell, @exploits, @defaultHeaders, @OTHERS, @ErrT);

#########################################################################################################################
## SET ENGINES
if (defined $mlevel && (!defined $shodan && !defined $bugtraq)) {
  if (defined $mrandom || $mrandom) { push @motor, $mrand; }
  elsif (defined $motor || $motor) { buildenginearray($motor); }
  else{
    push @motor, $motor1;
  }
}
#####################################################
## BUILD ENGINE ARRAY
sub buildenginearray {
  my $mtr=$_[0];
  if ($mtr=~/all/) { push @motor, @mrands; }
  if ($mtr=~/1/) { push @motor, $motor1; }
  if ($mtr=~/2/) { push @motor, $motor2; }
  if ($mtr=~/3/) { push @motor, $motor3; }
  if ($mtr=~/4/) { push @motor, $motor4; }
  if ($mtr=~/5/) { push @motor, $motor5; }
  if ($mtr=~/6/) { push @motor, $motor6; }
  if ($mtr=~/7/) { push @motor, $motor7; }
}

#########################################################################################################################
## SET ENGINES
for my $mot(@motor) {
  $mot=~s/MYBROWSERLANG/$browserLang/g;
  $mot=~s/MYGOOGLEDOMAINE/$googleDomain/g;
  $mot=~s/MYID/$Id/g;
  $mot=~s/MYMSID/$MsId/g;
  push @motors, $mot;
}

#########################################################################################################################
## CHECK GOOGLEAPIS CREDENCIALS
for my $mm(@motors) {
  if ($mm=~/googleapis./) {
    if (!defined $apikey || !defined $cx) {
	  _print_apis_alert();
	}
  }
}

#########################################################################################################################
## GET URLS FROM SEARCH ENGINE PAGES
sub doSearch {
  my ($Res, $motor)=@_;
  while($Res=~/$V_SEARCH/g) {
    my $URL=$1;
    if ($motor =~/$googleDomain/) { $URL=~s/\&.*//s; }
	$URL=do_needed($URL) if $URL;
  }
}

#########################################################################################################################
## GET URLS FROM GOOGLE APIS ENGINE PAGES
sub doSearchApis {
  my ($Res, $motor)=@_;
  use JSON;
  $Res=_json($Res);
  my @found = @{ $Res->{'items'} };
  for my $found(@found) {
	my $link = $found->{'link'};
	$link=do_needed($link) if $link;
  }
}
  
#########################################################################################################################
## EXTRAT CONDITIONS
sub do_needed {
  my $URL=$_[0];
  utf8::encode($URL);
  $URL = uri_unescape($URL);
  $URL=decode_entities($URL);
  $URL=~s/<.*//s;
  if ($URL!~/$nolisting/) {
    if (!defined $mindex && (defined $unique or defined $ifinurl || $unique)) {
      my $dorkToCheeck=checkFilters($dork);
      $URL=filterUr($URL, $dorkToCheeck);
    }
	if ((defined $mdom) || (defined $expHost) || (defined $expIp) || (defined $WpSites) || (defined $JoomSites)) {               
      $URL=getHost($URL);
    }
    my $vURL=validateURL($URL);
    if ($vURL) {
      push @aTsearch, $URL;
    }
  }
}

#########################################################################################################################
## PRINT INFO ENGINE
sub printMotor {
  my @motors=@_;
  print $c[1]."[::] $DS[29] :  ".$c[10];
  if (defined $mrandom || $mrandom) { print "[$TT[12]\]"; }
  for my $motor(@motors) {
    $motor=~s/MYBROWSERLANG/$browserLang/g;
    $motor=~s/MYGOOGLEDOMAINE/$googleDomain/g;
    my $l2;
    if ($motor=~/((all|bing.|google.|ask.|yandex.|sogou.|exalead.|googleapis.)(.*)\/)/) { 
	  my $mt=$1;
	  $mt=~s/\/.*//s;
	  print "$mt";
	}
  }
  print "\n";
}

#########################################################################################################################
## PRINT INFO DORK
sub printDork {
  my @dor=@_;
  if (defined $mindex) {
    print $c[1]."[::] SCAN   : $c[10] Engine Index\n";
  }  
  print $c[1]."[::] $DS[0]   : $c[10] $dork\n";     
  if ($zone) { print $c[1]."[::] ZONE  : $c[10] $zone\n"; }
  print $c[1]."[::] $DS[18]  : $c[10] $mlevel Page(s)\n";
  if (defined $ifinurl || defined $unique || $unique || defined $searchRegex) {
    print $c[1]."[::] $SCAN_TITLE[24]  : $c[10]";
    if (defined $ifinurl) { print "$TT[19] "; }
    if (defined $unique || $unique) { print "$DS[30] "; }
    if (defined $searchRegex) { print "$searchRegex "; }
    print "\n"; 
  }
  ptak();
}

#########################################################################################################################
## ENGINE PROCEDURE
sub msearch {  
  scanTitleBgn();
  print $c[11]."$SCAN_TITLE[0]"; scanTitleEnd();
  printMotor(@motors);
  printDork(@dorks);
  print $c[4]."[i] $DT[31]\n";
  $mlevel=$mlevel * 10;
  for my $motor(@motors) {
    for my $dork(@dorks) {
      if (defined $Target) {
	    if ($dork=~/$V_IP/) {
		  $dork="ip%3A$dork";
		}else{
	      if (defined $mindex) {
            $dork=getHost($dork);
            $dork=removeProtocol($dork);
            $dork=cleanURL($dork);
            $dork="site:".$dork;
		  }
		}
      }
      if ($zone) { $dork="site:$zone ".$dork; }    
      $dork=~s/\s+$//;
      $dork=~s/ /+/g;
      $dork=~s/^(\+|\s+)//g;
      if (length $dork > 0) {      
        $motor=~s/MYDORK/$dork/g;
        for(my $npages=1;$npages<=$mlevel;$npages+=10) {
          $motor=~s/MYNPAGES/$npages/g;
          if ($motor =~/MYAPIKEY/) {
		    my $api_key=get_conected_apikey();
            $motor=~s/MYAPIKEY/$api_key/;
			$motor=~s/MYCX/$cx/g;
          }
		  ckeck_ext_founc("");
          my $search=$ua->get("$motor");
          $search->as_string;
          my $Res=$search->content;
		  if ($motor eq 7) {
            doSearchApis($Res, $motor);  
		  }else{
            doSearch($Res, $motor);  
		  }
          $motor=~s/=$npages/=MYNPAGES/ig;
        }
        $motor=~s/\Q$dork/MYDORK/ig;
      }
    }
  }
} 

#########################################################################################################################
## BUILD ENGINE URL
sub printEngineInfo { 
  my ($dork, $motor, $npages)=@_;
  $motor=~s/MYDORK/$dork/g;
  $motor=~s/MYID/$Id/g;
  $motor=~s/MYMSID/$MsId/g;
  $motor=~s/MYNPAGES/$npages/g;
  return $motor;
}

#########################################################################################################################
## INFO URL SCAN
sub printInfoUrl {
  my ($URL1, $data)=@_;
  my $o=OO();
  our ($command, $port);
  if ($o < $limit) {
    if (!defined $noverbose && !$noverbose && !defined $geoloc) {
      if (defined $brandom || $brandom) {
        print $c[1]."    $ErrT[21] $c[8]  New agent !\n";
      }
      print $c[1]."    $SCAN_TITLE[23]   $c[10]$agent\n";
      print $c[1]."    $OTHERS[19]  $c[10]";
      if (defined $get || ($method and $method eq "get")) { print "$DS[15]\n"; }
      elsif (defined $post || ($method and $method eq "post")) { print "$DT[32]\n"; }
      elsif (defined $mupload || ($method and $method eq "upload")) { print "UPLOAD\n"; }
      else{ print "$DS[15]\n"; }
      if ($timeout or defined $timeout) { print $c[1]."    $TT[10] ".$c[10]."$timeout s\n"; }
      if (defined $headers) { print $c[1]."    HEADERS ".$c[10]."$headers\n"; }
      for (our @replace) {
        if (defined $_) {
          print $c[1]."    $OTHERS[14]   "; print $c[10]."[$_]\n";
        }
      }
      if (defined $noQuery) { print $c[1]."    $DS[16] $c[10]  $DS[40]\n"; }
    }
  }
}

#########################################################################################################################
## BROWES URL
sub browseUrl {
  my ($URL1, $data)=@_;
  printInfoUrl($URL1, $data);
  my ($response, $html, $status, $serverheader, $command, $port, $fullHeader);
  ($response, $html, $status, $serverheader)=getHtml($URL1, $data);
  my $o=OO();
  if ($o < $limit) {
    if (!defined $noverbose && !$noverbose && !defined $geoloc) { 
      if ($response->previous) { print $c[1]."    $DS[1]    $c[4]$DT[36]", $response->request->uri, "\n"; }
      my $ips=checkExtraInfo($URL1);
      print $c[1]."    $DS[10]      ";
      if ($ips) { my $ad=inet_ntoa($ips); print $c[10]."$ad\n"; }
      else{ print $c[10]."$DT[35]\n"; }
      checkCms($html); 
      checkWPlugins($html);
	  checkInputs($html);
	  checkErrors($html);
      if (!defined $fullHeaders) {        
        print $c[1]."    $DS[3]    ". $c[10]."$DS[13] $status\n"; print $c[1]."    $DS[2]  ";
        if (defined $serverheader) { print $c[10]."$serverheader\n"; } 
        else { print $c[10]."$DT[35]\n"; }
      } 
      if (defined $output) { print $c[1]."    OUTPUT  ". $c[10]."$output\n"; }
    }
  }
  return ($response, $status, $html);
}

#########################################################################################################################
## FORM DETECTION
sub checkInputs {
  my $html=$_[0];
  my $ni=0;
  for my $input(@V_INPUT) {
    my $type="type=";
    $type.= "\"$input\"";
	if ($html=~/<input(.*)$type/) {
	  $ni++; 
	  print $c[1]."    FORMS  $c[4] [!]$c[10] Form inputs detected!\n";
	  last;
	} 
  }
}

#########################################################################################################################
## WP PLUGINS DETECTION
sub checkWPlugins {
  my $html=$_[0];
  my @plugins;
  my $ipl=0;
  my @base=("plugins", "themes");
  for my $base(@base) {
    while ($html=~/\/wp-content\/$base\/(.*?)(\/)/g) {
	  $ipl++;
	  $1=~s/\/wp-content\/$base\//$base/g;
	  my $chop=$base;
	  chop($chop);
	  my $fullPlug="$chop => $1";
	  push @plugins, $fullPlug;
	}
  }
  if (scalar @plugins > 1) {
    @plugins=checkDuplicate(@plugins);
	print $c[1]."    PLUGINS$c[4] [!]$c[10] [IMPORTANT INFO]\n";
	for my $fullP(@plugins) {
	  print $c[10]."            - $fullP\n";
	}
  }  
}  

#########################################################################################################################
## GET HTML
sub getHtml {
  my ($URL, $data)=@_;
  our (@ErrT, $freq, $start, $date);   
  my ($prox, $re, $ht, $st, $sh, $fh);
  ckeck_ext_founc("1");
  if ($data) {
    $data=dataFields($data);
    if (defined $post || ($method && $method eq "post")) {
      $re=$ua->post($URL, content_type => 'application/x-www-form-urlencoded', Content => [$data]);
    }elsif (defined $mupload || ($mupload && $mupload eq "upload")) {
      $re=$ua->post($URL, Content_Type => 'multipart/form-data', Content => [$data]);
    }elsif (defined $get || ($method && $method eq "get")) {
      $URL.="?".$data;
      $URL=~s/\s//g;
      $re=$ua->get($URL);
    }
  }else{
    if (defined $post || ($method && $method eq "post")) {
      $re=$ua->post($URL); }
    elsif (defined $get || ($method && $method eq "get")) {
      $re=$ua->get($URL);
    }else{
      $re=$ua->get($URL);
    }
  }
  $ht=$re->decoded_content;
  $st=$re->code;
  $sh=$re->server;
  $fh=$re->headers_as_string;    
  
  if (defined $fullHeaders) {
    my $Hcopy="$Bin/inc/conf/user/HeadersTemp.txt";
    unlink $Hcopy if -e $Hcopy;
    printFile($Hcopy, $fh);
  }
  return ($re, $ht, $st, $sh);
}

#########################################################################################################################
## GET DATA FORM FIELDS
sub dataFields {
  my $data=$_[0];
  $data=~s/\s/\+/g;
  $data=~s/\+=>/\=>/g;
  $data=~s/\=>\+/\=>/g;
  if (defined $get) {
    $data=~s/\=>/\=/g;
    $data=~s/\,\+/\,/g;
    $data=~s/\,/\&/g;
  }else{
    $data=~s/\=>/\=>'/g;
    $data=~s/\,/\',/g;
    $data=~s/\+/ /g;
    $data.="'";
  }
  return $data;
}

#########################################################################################################################
## REGEX SCANS / EMAIL / IP / REGEX
sub getRegex {
  my ($URL1, $html, $reg)=@_;
  my $o=OO();
  if ($o < $limit) {
    if (!defined $searchIps and !defined $eMails) {
      print $c[1]."    $SCAN_TITLE[25]  $c[10]";
      print "$reg] \n";
    }
    titleSCAN();
    my $hssab=0;
    while ($html=~/$reg/g) {
      my $o=OO();
      if ($o < $limit) {
        my $validRegex=checkValidation($1, "", $html, "", "");
        if ($validRegex) {     
          $hssab++;
          print " | " if $hssab>1;
          print $c[3]."$validRegex";
          saveme($validRegex, "1");
        }
      }
    }
    if ($hssab<1) {
      noResult();
    }else{
      print "\n";
      if (defined $command) { checkExternComnd($URL1, $command); }
    }
  }
}

#########################################################################################################################
## EXECUTE EXTERN PROCESS COMMANDS
sub getComnd {
  my ($u, $comnd)=@_;
  $u=~s/(\sAND|\%27|\<|\>|\"\<|\"\>|\'\<|\'\>|\"\;|\<\%25|\%|\').*//ig;
  if ($u=~/($V_IP)/) {
    $u=removeProtocol($u);
    if ($comnd=~/-PORT/) {
      if ($u=~/(($V_IP)\:(\d{2,6}))/) {
        $u=~s/\:/\./g;
        my @f=split /\./, $u;
        my $Addr="$f[0].$f[1].$f[2].$f[3]";
        my $Port=$f[4];
        $comnd=~s/\-\-TARGET/$Addr/ig;
        $comnd=~s/\-\-PORT/$Port/ig;
      }else{
        $comnd=~s/\-\-TARGET/$u/ig;
      }
    }elsif ($comnd=~/\-HOSTIP/) {
      $u=~s/\:(\d{2,6})//s;
      $comnd=~s/\-\-HOSTIP/$u/ig;
    }else{
      $comnd=~s/\-\-TARGET/$u/ig;
    }    
  }else{
    $comnd=replaceReferencies($u, $comnd);
  }
  if (defined $popup) {
    $comnd="sudo xterm -title '$u' -hold -e '$comnd'";
    print "$c[4]            [!] $c[10]Opening process in extern window..\n";
    sleep 2;
    print $c[8]."            ";
    system("$comnd & ");
  }else{
    print $c[8]."            ";
    system("$comnd");
  }
  print "\n    ";
}

#########################################################################################################################
## MAKE SCAN WITH EXPLOIT IN ARRAY
sub getExploitArrScan{
  my ($URL, $arr, $filter, $result, $reg, $comnd, $isFilter, $pm, $pmarr, $data)=@_;
  if (defined $exploit || defined $expHost || defined $expIp) {
    my $lc=scalar @exploits;
    my $count3=0;
    for my $exp(@exploits) {
      $exp=~s/\s+$//;
      my $o=OO();
      if ($o < $limit) {
	    $count3++; points() if $count3>1;
        if ($arr) { print $c[1]."    $DS[5]  $c[10] [$pm/$pmarr] $arr\n" if $count3>1; }
        print $c[1]."    $DS[6]$c[10] [$OTHERS[1] $count3/$lc] $exp\n" if !defined $p;
        if (defined $p) {
          if ($arr) { getPArrScan($URL, $arr, $filter, $result, $reg, $comnd, $isFilter, $pm, $pmarr, $exp, $lc, $count3, $data); }
          else{ getPArrScan($URL, "", $filter, $result, $reg, $comnd, $isFilter, "", "", $exp, $lc, $count3, $data); }
        }else{
          if ($arr) { my $URL1=$URL.$exp.$arr; $URL1=~s/ //g; doScan($URL1, $filter, $result, "", $reg, $comnd, $isFilter, $data); }
        else{ my $URL1=$URL.$exp; $URL1=~s/ //g; doScan($URL1, $filter, $result, "", $reg, $comnd, $isFilter, $data); }
        }
      }
    }
  }else{
    if ($arr) { getPArrScan($URL, $arr, $filter, $result, $reg, $comnd, $isFilter, $pm, $pmarr, "", "", "", $data); }
    else{ getPArrScan($URL, "", $filter, $result, $reg, $comnd, $isFilter, "", "", "", "", "", $data); }
  }
}

#########################################################################################################################
## MAKE SCAN WITH DEFINED PARAMETERS
sub getPArrScan{
  my ($URL, $arr, $filter, $result, $reg, $comnd, $isFilter, $pm, $pmarr, $exp, $lc, $count3, $data)=@_;
  if (defined $p) {
    my @P;
    if ($p=~/all/) {
	  while ($URL=~/((\?|\&).*?)=/g) { 
	    my $ppz=$1;
        $ppz=~s/\?//g;
	    $ppz=~s/\&//g; 
	    push @P, $ppz; 
	  }
    }else{
	  @P=split(",", $p);
    }  
    my $pc=0;
    foreach my $P(@P) {
      my $o=OO();
      if ($o < $limit) {
        $pc++;
        points() if $pc>1;
        if ($exp) { print $c[1]."    $DS[6]$c[10] [$OTHERS[1] $count3/$lc] $exp\n"; }
        if ($arr) { print $c[1]."    $DS[5]  $c[10] [$pm/$pmarr] $arr\n" if $pc>1; }
		print $c[1]."    $OTHERS[16]  $c[10] [$pc/".scalar @P."] $P\n";		
		if ($URL!~/(\?|\&)$P/) { 
		  print $c[1]."    $DS[4]:   $c[2]$OTHERS[17] [$P]\n";
		}else{
          my $URL1=$URL;
          if (index($URL, "\?$P=") != -1) { 
		    $URL1=~s/\?$P=([^&]*)/\?$P=$1$exp$arr/g; 
		    doScan($URL1, $filter, $result, "", $reg, $comnd, $isFilter, $data);
		  }elsif (index($URL, "\&$P=") != -1) { 
		    $URL1=~s/\&$P=([^&]*)/\&$P=$1$exp$arr/g; 
		    doScan($URL1, $filter, $result, "", $reg, $comnd, $isFilter, $data);
	      }
		}
      }
    }
  }
}          

#########################################################################################################################
## MOVE URL TO SCAN
sub doScan {
  my ($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $data)=@_;
  my ($i, $sl, $rangQ);
  $URL1.=$shell if defined $shell;
  my $n=0;
  if ($URL1=~/rang\((\d+)\-(\d+)\)/) {
    my @rangQ=($1 .. $2);
    $URL1=~s/rang\((\d+)\-(\d+)\)/ RPEATR /g;
    for $rangQ(@rangQ) {
      my $o=OO();
      if ($o < $limit) {
        $n++; points() if $n>1;
        doBuild($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $rangQ, scalar @rangQ, $n, $data);
      }
    }
  }elsif ($URL1=~/repeat\((.*)\-(\d+)\)/) {
    $URL1=~s/repeat\((.*)\-(\d+)\)/ RPEATR /g;
    for($i=1;$i<=$2;$i++) {
      my $o=OO();
      if ($o < $limit) {
        $n++; points() if $n>1;
        $sl="$1" x $i; doBuild($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $sl, $2, $n, $data);
      }
    }
  }else{ buildPrint($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $data); }
}

#########################################################################################################################
## DO BUILD
sub doBuild {
  my ($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $rangQ, $nn, $n, $data)=@_;
  my $o=OO();
  if ($o < $limit) {
    $URL1=~s/ RPEATR /$rangQ/ig;
    my $PURL1=$URL1;
    print $c[1]."    URL    $c[10] [$n/$nn] $PURL1\n";
    buildPrint($URL1, $filter, $result, $reverse, $reg, $comnd, $isFilter, $data);
  }
}

#########################################################################################################################

1;
