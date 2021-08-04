function RunAutomatedTests {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$tag
    )
    Write-Host "Build docker image for automated testing"

    docker build -t superservicetest:$tag --target test . 


    Write-Host "Run automated tests in a container"

    docker run -i --rm superservicetest:$tag


}

function BuildAndDeploy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$tag
 
    )
          
    Write-Host "Build docker image with superservice"

    docker build -t superservice:$tag . 


    Write-Host "Run docker container - superservice"

    docker run -it --rm -p 8080:8080 superservice:$tag
}

  