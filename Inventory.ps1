#This part of the file dealas with downloading the file and creating initial CSV file from JSON
#--------------------------------------------------------------------------------------------
clear-host # cleaning the screen before executing 
$current_location =split-path -parent $MyInvocation.MyCommand.Definition #getting current location
$path =  $current_location + '\' #path to the folder where files will be stored need to add \ onlt this way
$internal_directory = $path + 'EMPLOYEE_FILES\'
New-Item -ItemType Directory -Force ($internal_directory) > $null 
$path = $internal_directory
$fromfile = "http://10.211.100.50:2020/api/extractMDWdata?criteria=EMPLOYEE_" #The initial address of the link 
$jsonfile  = ($path + "JSON_EMPLOYEE_.json") #this is where we will save JSON
$csvfile   = ($path + "INVENTORY_EMPLOYEE_.csv")   #this is where we will save CSV

$webclient = New-Object System.Net.WebClient #initiate webclient

$webclient.UseDefaultCredentials = $true

$webclient.DownloadFile($fromfile, $jsonfile) #download file from our link to json

$obj = Get-Content $jsonfile -Raw | ConvertFrom-Json #create object from the json file

$list = $obj.results.PSObject.Properties.Name #take the list of the objects inside of out json object.results

echo ("")

echo ('Lines in the JSON object: ' + $list.Length)


$counter = 0 #this variable will count each succesfull line processed

$formated = foreach($x_name in $list){ #for each name in the list create a line in table

        #$obj.results.$x_name #interestingly enough this will already print everything we need, but not namless
           $counter+=1 
           [pscustomobject]@{
             name = $x_name.Trim()
             app_code = $obj.results.$x_name.app_app_code
             attestation = $obj.results.$x_name.attestation
             capped = $obj.results.$x_name.capped
             comments = $obj.results.$x_name.comments
             end_of_support = $obj.results.$x_name.end_of_suppor
             environment = $obj.results.$x_name.environment
             ha_version = $obj.results.$x_name.ha_version
             last_edited_by = $obj.results.$x_name.last_edited_by
             platform = $obj.results.$x_name.platform
             service_window_cycle = $obj.results.$x_name.service_window_cycle
             software_component = $obj.results.$x_name.software_component
             status = $obj.results.$x_name.status
             version = $obj.results.$x_name.version
         }
}

$formated | Export-Csv $csvfile -notype #append all the lins to csv file

echo ('Lines processed: '+ $counter) #letting user know how many lines were proccessed 

#This part of the file deals with parsing the newly created CSV into workable files
#--------------------------------------------------------------------------------------------

echo ("") #printing blank line
echo ('Importing file: ' + $csvfile)
$all_EMPLOYEE_ = Import-Csv $csvfile #importing file as csv

$hr = @() #3 blank arrays
$it = @() 
$fx = @()

#counters for debugging 
$hr_count = 0
$fx_count = 0
$it_count = 0
$other_count = 0

foreach ($line in $all_EMPLOYEE_) #going thru csv file line by line
{
    $platform = $line.platform #grab the platform cell so we can compare it to one of the 3
    If($platform -eq 'fx') 
    {
        $fx += $line #appending array 
        $fx_count +=1
    } 
    ElseIf($platform -eq 'it') 
    {
        $it_count+=1
        $it += $line
    } 
    ElseIf($platform -eq 'hr') 
    {
        $hr_count+=1
        $hr += $line
    } 
    else
    {
        $other_count+=1
    }
}

#for user to see what EMPLOYEE_ in the file
echo ('------------------')
echo ('HR Count     : ' + $hr_count)
echo ('IT Count     : ' + $it_count)
echo ('FX Count     : ' + $fx_count)
echo ('Other Count  : ' + $other_count)
echo ('__________________')
echo ('Total Count  : ' + ($hr_count + $it_count + $fx_count + $other_count))
echo ('------------------')

echo 'File downloaded and parsed, execute SQL?'

$hr |  Select 'name', 'app_code','version', 'environment'| Export-CSV ($path+"EMPLOYEE_Inventoryhr.csv") -NoTypeInformation #save hr file csv
$it | Select 'name', 'app_code', 'title','version', 'environment'| Export-CSV ($path + "EMPLOYEE_Inventoryit.csv") -NoTypeInformation #save it file csv
$fx | Select 'name', 'app_code', 'environment','version'| Export-CSV ($path+"EMPLOYEE_Inventoryfx.csv") -NoTypeInformation #save fx file csv

cmd.exe /c ($current_location + '\Inventory.bat')
