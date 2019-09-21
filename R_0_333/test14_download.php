<!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>
<?php

$subjects = array("math1","programming","drawing","physics","applied","electrical","vacant","math2","drawing2","electronics","chemistry","thermo","workshop","vacant","math3","OOP","ckt","material","EDC","digitallogic","magnetics","machine","NM","maths","instrumenatation","power","microprocessor","discrete");
$firstValues;
$once = true;

if(!isset($_POST['next']) and !isset($_POST['sumit']))
{
echo "hello";
?>
<p>
<b>file to download of:</ br></b>
</p>
	<form action="test14_download.php" method="POST" >
	<p>
		Choose the year ? </ br>
		<select name="year">
			<option value="">Select...</option>
			<option value="1">First</option>
					<option value="2">Second</option>
			<option value="3">Third</option>
			<option value="4">Fourth</option>
		</select>
	</p>
	<p>
		<br>Choose part ?</ br>
		<select name="part">
			<option value="">Select...</option>
			<option value="1">first</option>
			<option value="2">second</option>
		</select>
	</p>
    	<input type="submit" value="NEXT" name="next">
</form>

<?php
}
if(isset($_POST['next']))
{
if($once)
{
	print_r($_POST);
	// $_SESSION['info'] = $_POST;
	//print_r($firstValues);
	// print_r($_SESSION['info']);
 	$once = false;
}
?>
<br> select the subject on which wish to operate :-<br>
<form action="test14_list.php" method="POST" enctype="multipart/form-data">
	<p>
		Choose the year?
		<select name="subject">
<?php
for ($i = 0; $i < 7; $i++) 
{
			$count = 14*($_POST['year']-1)+7*($_POST['part']-1)+$i;
	  	echo "<option value=\"".$subjects[$count]."\">".$subjects[$count]."</option>";
}
?>			
</ br>
</p>
<p>
    	<input type="submit" value="ListFile" name="submit">
		</select>
</p>	
</form>
<?php
}
?>
</body>
</html>