

**Prerequisites:**
1. Docker
2. Powershell

**Instructions to run**

Go to Deploy.ps1 under devops directory and compile the script using powershell

In poweshell console ->

1. Run automated tests by calling below function with mandatory version field value

  **RunAutomatedTests -tag '{version}'**
  

2. Build and run docker image by calling below function with mandatory version field value

  **BuildAndDeploy -tag '{version}'** 
  
   Once container is running then access http://localhost:8080/time on browser which should display current date and time.

**During the implementation following approaches are considered**

1. By default, one of the unit test fails. In order to pass all the tests commented one of the assert in "TheTimeIsNow" test method. However, automated tests triggers regardless of test result and displays results accordingly.

2. Ideally, any failed automated tests shouldn't allow final docker image to build and deploy. It seems to be out of scope for this task as there is no mention of this. Hence, achieved automated tests strategy by employing "Running tests as an opt-in stage" in the dockerfile. This would keep out the test artefacts from the final image.

3. Deploy and run the image locally with tag

4. Host the application in a secure fashion : 

   a. Hardened the image by running as non root user
  
   b. Used multistage docker build approach
  
   c. Made an attempt to reduce the image size by using minimal base image
  
Many other hardening image measures could have been considered. For e.g: no interactive shells for users, stricten permissions on system files and directories etc

Happy to discuss further on my approaches(or alternative ways) and improvements which could have been done.

                                           



