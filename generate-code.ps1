[cmdletbinding()]
param()

function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

$scriptDir = ((Get-ScriptDirectory) + "\")

$pre = @'
<!DOCTYPE HTML>
<!--
	Photon by HTML5 UP
	html5up.net | @n33co
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
	<head>
		<title>Ibrahim and Farishta gift card ideas</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
		<link rel="stylesheet" href="assets/css/main.css" />
		<!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
		<!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
	</head>
	<body>

		<!-- Header -->
			<section id="header">
				<div class="inner">
					<span class="icon major fa-cloud"></span>
					<h1>Ibrahim and Farishta - Gift card ideas</h1>
				</div>
			</section>

			<section id="three" class="main style1 special">
'@
$post = @'

			</section>
		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/jquery.scrolly.min.js"></script>
			<script src="assets/js/skel.min.js"></script>
			<script src="assets/js/util.js"></script>
			<!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
			<script src="assets/js/main.js"></script>

	</body>
</html>
'@
function Generate-Html{
    [cmdletbinding()]
    param(
        [System.IO.FileInfo]$filepath
    )
    begin{
        $pre
    }
    end{
        $post
    }
    process{
        $data = ConvertFrom-Json ([System.IO.File]::ReadAllText($filepath))
        $index = 3
        $closedLast = $false
        $countsinceclose = 0
        foreach($item in ($data.items)){
            $closedLast = $false
            $printclosing = $false
            if( ($index % 3 ) -eq 0){
				'				<div class="container">'
				'					<div class="row 150%">'
                $countsinceclose = 0
            }
           
            $formatNostore = @'
						        <div class="4u 12u$(medium)">
							        <span class="image"><img src="{0}" alt="" /></span>
							        <h3>{1}</h3>
							        <ul class="actions">
								        <li><a href="{2}">Buy online</a></li>
							        </ul>
						        </div>
'@
            $formatWithstore = @'
						        <div class="4u 12u$(medium)">
							        <span class="image"><img src="{0}" alt="" /></span>
							        <h3>{1}</h3>
							        <ul class="actions">
								        <li><a href="{2}">Buy online</a></li>
								        <li><a href="{3}">Find a store</a></li>
							        </ul>
						        </div>
'@
            $formatTouse = $formatNostore
            if(-not([string]::IsNullOrWhiteSpace($item.'store-search'))){
                $formatTouse = $formatWithstore
            }

            $formatTouse -f ($item.image),($item.title),($item.url),($item.'store-search') | Write-Output

            $countsinceclose++
            if( $countsinceclose -eq 3){
                '					</div>'
                '				</div>'
                $closedLast = $true
            }
            $index++
        }

        if($closedLast -eq $false){
                            '</div>'
                        '</div>'
        }
    }
}


$result = Generate-Html -filepath (Join-Path $scriptDir data.json)
$result | Set-Content -Path (Join-Path $scriptDir index.html)