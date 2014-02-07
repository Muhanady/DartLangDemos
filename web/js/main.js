$(document).ready(function(){
	$("#tableDiv table td").click(function(){
		$(this).addClass("Clicked");
	});
	$(".animasyonoynat").click(function(){
		$(".Cover").fadeIn();
		$("#tableDiv .MYXOAlert").addClass("Animated");
	});
})