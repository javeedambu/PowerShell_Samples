# Send Virtualization Reports

$AlertFrom = "noreply-myemail@somedomain.com"

$AlertTo = "toemail@somedomain.com"

$AlertSubject = "DailyReports"

$AlertBody = "`r`n" + "Daily Reports" + `
            "`r`n" + "=============================" + `
            "`r`n `r`n" + " # File1.csv" + "`r`n" + " - File1 Report" + `
            "`r`n `r`n" + " # File2.csv" + "`r`n" + " - File2 Report"

$AlertAttachment = "E:\Reports\File1.csv", `
                "E:\Reports\File2.csv"

$SMTPserver = "mail.somedomain.com"

Send-MailMessage -To $AlertTo -From $AlertFrom -Subject $AlertSubject -Body $AlertBody -Attachments $AlertAttachment -SmtpServer $SMTPServer 
