<html>
<head>
</head>

<body>
<?php

echo "welcome";
$x1 = 100;
function assignx()
{
	global $x1;
	$x = 0;
	printf("\n\r\$x inside function is %d ", $x);
	printf("\n\r\$x1 global varaible inside function is %d ", $x1);
}
echo "<br />";
assignx();
printf("\n\r\$x outside function is %d ", $x);

foreach($_SERVER as $var => $value)
{
	echo "$var => $value <br />";
}
?>

</body>
</html>
