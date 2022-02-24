<?php

$file_url = '/secrets/env/credentials.json';
$env_file = '/var/www/html/.env';

$credentials = (array) json_decode(file_get_contents($file_url));

// open file
$str = file_get_contents($env_file);
$fp = fopen($env_file, 'w');
foreach ($credentials as $key => $value) {
    $str = str_replace("{{$key}}", "'$value'", $str);
}

fwrite($fp, $str);
fclose($fp);