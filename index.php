<?php
if(isset($_POST["fetchcart"])){
	$con=mysqli_connect("localhost","root","","exampletest");
	if(mysqli_connect_error()>0){
		$arr["msg"]=mysqli_connect_error();
	}
	else{
		$query="select * from exam";
		$statement=$con->prepare($query);
		$statement->execute();
		$statement->store_result();
		if($statement->num_rows>0)
		{
			$statement->bind_result($Qno,$Question,$Answer1,$Answer2,$Answer3,$Answer4,$Correct_Answer,$Points);
			$arr["count"]=$statement->num_rows;
			$i=1;
			while($statement->fetch()){
				$arr["Qno".$i]=$Qno;
				$arr["Question".$i]=$Question;
				$arr["Answer1".$i]=$Answer1;
				$arr["Answer2".$i]=$Answer2;
				$arr["Answer3".$i]=$Answer3;
				$arr["Answer4".$i]=$Answer4;
				$arr["Correct_Answer".$i]=$Correct_Answer;
				$arr["Points".$i]=$Points;
				$i++;
			}
		}
		else
		{
			$arr["msg"]="Question not found";
		}
	}
	echo json_encode($arr);
}
if(isset($_POST["add"])){
	$sname=$_POST["sname"];
	$qno=$_POST["qno"];
	$canswer=$_POST["canswer"];
	$givenans=$_POST["givenans"];
	$point=$_POST["point"];
	$con=mysqli_connect("localhost","root","","exampletest");
	if(mysqli_connect_error()>0){
		$arr["msg"]=mysqli_connect_error();
	}
	else
	{
		$query="insert into result(Student_name,Qno,Correct_answer,Given_Answer,Points) values(?,?,?,?,?)";
		$statement=$con->prepare($query);
		$statement->bind_param("sissi",$sname,$qno,$canswer,$givenans,$point);
		$statement->execute();
		$statement->store_result();
		if($statement->affected_rows>0){
			$arr["msg"]="data is inserted";
		}
		else
		{
			$arr["msg"]="data is not inserted";
		}
	}
echo json_encode($arr);
}
if(isset($_POST["check"])){
	$Student_name=$_POST["Student_name"];
	$con=mysqli_connect("localhost","root","","exampletest");
	if(mysqli_connect_error()>0){
		$arr["msg"]=mysqli_connect_error();
	}
	else{
		$query="select * from result where Student_name=?";
		$statement=$con->prepare($query);
		$statement->bind_param("s",$Student_name);
		$statement->execute();
		$statement->store_result();
		if($statement->num_rows>0)
		{
			$arr["msg"]="found";
		}
		else
		{
			$arr["msg"]="not found";
		}
	}
	echo json_encode($arr);
}
if(isset($_POST["show"])){
	$Student_name=$_POST["Student_name"];
	$con=mysqli_connect("localhost","root","","exampletest");
	if(mysqli_connect_error()>0){
		$arr["msg"]=mysqli_connect_error();
	}
	else{
		$query="select SUM(Points)from result where Correct_answer=Given_Answer and Student_name=?";
		$statement=$con->prepare($query);
		$statement->bind_param("s",$Student_name);
		$statement->execute();
		$statement->store_result();
		if($statement->num_rows>0)
		{
			$statement->bind_result($score);
			$statement->fetch();
			$arr["score"]=$score;
		}
		else
		{
			$arr["score"]=0;
		}

		$query="select SUM(Points)from result where Student_name=?";
		$statement=$con->prepare($query);
		$statement->bind_param("s",$Student_name);
		$statement->execute();
		$statement->store_result();
		if($statement->num_rows>0)
		{
			$statement->bind_result($score);
			$statement->fetch();
			$arr["totalscore"]=$score;
		}
		else
		{
			$arr["totalscore"]=0;
		}
	}
	echo json_encode($arr);
}
if(isset($_POST["detailscore"])){
	$Student_name=$_POST["Student_name"];
	$con=mysqli_connect("localhost","root","","exampletest");
	if(mysqli_connect_error()>0){
		$arr["msg"]=mysqli_connect_error();
	}
	else{
		$query="select r.Qno,r.Correct_answer,r.Given_Answer,e.Question ,r.Points from result r, exam e where r.Student_name=? and r.Qno=e.Qno";
		$statement=$con->prepare($query);
		$statement->bind_param("s",$Student_name);
		$statement->execute();
		$statement->store_result();
		if($statement->num_rows>0)
		{
			$statement->bind_result($Qno,$Correct_answer,$Given_Answer,$Question,$Points);
			$arr["count"]=$statement->num_rows;
			$i=1;
			while($statement->fetch()){
				$arr["Qno".$i]=$Qno;
				$arr["Question".$i]=$Question;
				$arr["Given_Answer".$i]=$Given_Answer;
				$arr["Correct_answer".$i]=$Correct_answer;
				$arr["Points".$i]=$Points;
				$i++;
			}
		}
		else
		{
			$arr["msg"]="Question not found";
		}
	}
	echo json_encode($arr);
}
?>