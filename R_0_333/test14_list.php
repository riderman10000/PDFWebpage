<!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>
<?php
	$target_folder = $_POST['subject'];
	echo $target_folder;
	$mysqli = new mysqli('localhost','spiderman','peter1994','hero');
	//checking the connection
	if($mysqli->connect_error)
	{
		die("connection failed : ".$mysqli->connect_error);
	}
	echo "connection with database successful <br />";
	//for displaying the records available...
	$query = "SELECT id,name,location FROM ".$target_folder.";";
	$result = $mysqli->query($query,MYSQLI_STORE_RESULT);
	print_r($result);
	while(list($id,$name,$location)= $result->fetch_row())
		printf("%s %s: %s <br />",$id,$name,$location);
	echo "<pre>";
	printf("hello <br />");
	$result = $mysqli->query($query,MYSQLI_STORE_RESULT);
	while(list($id,$name,$location)= $result->fetch_row())
	{
		printf("hello <br />");
		printf("<br><a href = \"%s/%s\" download> %s </a>",$location,$name,$name);
	}
	echo "</pre>";
		// echo"<br><a href=\"".$location."/".$name."\" download>".$name."</a>";
	//*/
	printf("hello <br />");
	if($mysqli->errno)
	{
		printf("<br />Mysql error number generated : %d", $mysqli->errno);
		printf("<br />unable to connect to the database <br /> : %s ",$mysqli->error);
	}
	$mysqli->close();
?>
</body>
</html>