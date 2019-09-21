<?php
//require_once('test11.php');
session_start();
$array = $GLOBALS['firstValues'];
print_r($GLOBALS);
print("<br>");
print_r($_SESSION['info']);
print("<br>");
print_r($_POST);
$target_parent_dir = "/home/rimesh/Files/softwareFiles/php/project/";
$target_child_dir = $_SESSION['info'];		//year and semester info.
$target_folder = $_POST['subject']; 		//information about subject

$dirPath .= $target_parent_dir."year".$target_child_dir['year']."/".$target_child_dir['part']."sem/".$target_folder."/";

print($dirPath);
print("<br>");
print_r($_FILES);
// the fileToUpload use below is the id of the file and is named in the file that select
// and submit the file'

$target_file = $dirPath.basename($_FILES['file']['name']);
$uploadOk = 1;

if(isset($_POST['submit']))
{
	//print("inside the if submit");
	//check file if it is uploaded or not
	if(is_uploaded_file($_FILES['file']['tmp_name']))
	{
		//check file is pdf or not
		print("inside is_uploaded_file");
		if($_FILES['file']['type']!= 'application/pdf')
		{
			echo "<p> it is not pdf format </p>";
		}
		else 
		{
		//moving the uploaded file to the target dir
			if(move_uploaded_file($_FILES['file']['tmp_name'],$target_file))
			{
				echo "file is valid and was successfully uploaded.\n";
				print("in the sql section");
				//information about the database
				$mysqli = new mysqli('localhost','spiderman','peter1994','hero');
				//checking the connection
				if($mysqli->connect_error)
				{
					die("connection failed : ".$mysqli->connect_error);
				}
				echo "connection with database successful <br />";

				//query to create table of the subjects only if they don't exists. 
				$query = "CREATE TABLE IF NOT EXISTS ".$target_folder."( id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT, name VARCHAR(250) NOT NULL, location VARCHAR(250),PRIMARY KEY(id));";
				$result = $mysqli->query($query, MYSQLI_STORE_RESULT);
				print_r($result);

				//query to insert the information of the file into the database.
				// insert into math1(name,location) values('tesname','/home/rimesh/Files/softwareFiles/php/project/year1/1sem/math1/');
				$temporary = basename($_FILES['file']['name']);
				echo "<br />";
				echo $temporary;
				echo "<br />";

				$query = "SELECT id,name,location FROM ".$target_folder.";";
				$result = $mysqli->query($query,MYSQLI_STORE_RESULT);
				print_r($result);
				$repeat = 0;
				while(list($id,$name,$location)= $result->fetch_row())
				{
					printf("%s %s: %s <br />",$id,$name,$location);
					if(!strcmp($temporary,$name))
					{
						printf("the file already exists, if it is different rename");
						$repeat = 1;
					}
				}

				if(!$repeat)
				{
					$query = "INSERT INTO ".$target_folder."(name,location) VALUES('".$temporary."','".$dirPath."');";
					$result = $mysqli->query($query,MYSQLI_STORE_RESULT);
					print_r($result);
				}
				//for displaying the records available...
				$query = "SELECT id,name,location FROM ".$target_folder.";";
				$result = $mysqli->query($query,MYSQLI_STORE_RESULT);
				print_r($result);
				while(list($id,$name,$location)= $result->fetch_row())
					printf("%s %s: %s <br />",$id,$name,$location);//*/
				if($mysqli->errno)
				{
					printf("<br />Mysql error number generated : %d", $mysqli->errno);
					printf("<br />unable to connect to the database <br /> : %s ",$mysqli->error);
				}
				$mysqli->close();
			}
			else
			{
				echo "possible file upload attack! muhahaha....";
			}
		}
	}
}
?>