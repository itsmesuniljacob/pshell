#$reply = Read-Host -Prompt "This script will add git configuration settings globally. Continue?[y/n]"
param([switch]$reply=$false)
if($reply -match "[yY]") {
if($reply) {	
	param([String]$name,[String]$email)
	# $path = @('user.name','user.email','http.proxy','https.proxy')
	# $inp = @($name,$email,$proxy,$proxy)
	$path = @('user.name','user.email')
	$inp = @($name,$email)
	function isSuccess {
		param([String]$property = "unknown")
		if($?) {
			"Config $property... is updated"
		}
		else {
			"Config $property... is not updated"
			Exit
		}
	}

	$i=0
	do {
			Foreach ($p in $path) {
				git config --global $p $inp[$i]
				isSuccess -property $p
				$i++
			}
	} while ($i -lt 4)
} else {
	"Script aborted"
}
