<?php 

function test($job, &$log) {

    $workload = $job->workload();

    // do work on $job here as documented in pecl/gearman docs

    // Log is an array that is passed in by reference that can be
    // added to for logging data that is not part of the return data
    $log[] = "Success";

    // return your result for the client
    return $result;

}


?>