<?php
  $data = json_decode(file_get_contents('php://input'), true);
  header('Content-type: text/html');
  file_put_contents('./target_report/data.txt', $data, FILE_APPEND);
?>
