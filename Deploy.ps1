function RunAutomatedTests {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$tag
    )
    Write-Host "Build docker image for automated testing"

    docker build . --pull --no-cache -t superservicetest:$tag --target test


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

    docker build . --pull --no-cache -t superservice:$tag 


    Write-Host "Run docker container - superservice"

    docker run -it --rm -p 8080:8080 superservice:$tag
}

  
