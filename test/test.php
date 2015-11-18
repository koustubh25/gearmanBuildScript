<?php 

$gearmanso = False;
$pcntl = False;
$gearmand = False;
$gearman_manager = False;

$red = "\033[31m";
$green = "\033[32m";
$white = "\033[0m";

exec("sudo service gearmand restart  2> /dev/null &", $output, $return);
$return == 0 ? $gearmand = True : $gearmand = False;

$gearmanso=extension_loaded("gearman");
$pcntl=extension_loaded("pcntl");

echo "Gearman daemon ..." . printStatus($gearmand) . "\n";
echo "PHP Gearman extension ..." . printStatus($gearmanso) . "\n"; 

if(!$gearmanso){
	echo "Make sure you have copied gearman.so in php.ini.\n";	
}

echo "PHP pcntl extension  ..." . printStatus($pcntl) . "\n" ;

if(!$pcntl){
	echo "Make sure you have copied gearman.so in php.ini.\n";
}

if(!$pcntl || !$gearmanso){
	echo "Gearman Manager ..." . printStatus(False) . "\n";
}
else{
	exec("sudo service gearman-manager restart  2> /dev/null &", $output, $return);
	$return == 0 ? $gearman_manager = True : $gearman_manager = False;
	echo "Gearman Manager ..." . printStatus($gearman_manager) . "\n";
}

function printStatus($in){
	global $red, $green, $white;
	$in ? $msg = $green . " ok" . $white : $msg = $red . " not ok" . $white;
	return $msg;
}


?>