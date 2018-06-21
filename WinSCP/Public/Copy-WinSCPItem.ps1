function Copy-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Copy-WinSCPItem",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({
            if ($_.Opened) {
                return $true
            } else {
                throw "The WinSCP Session is not in an Open state."
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path,

        [Parameter()]
        [String]
        $Destination = $WinSCPSession.HomePath,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $PassThru
    )

    process {
        $Destination = Format-WinSCPPathString -Path $Destination
        $destinationInfo = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ErrorAction SilentlyContinue

        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            try {
                $shouldProcess = $PSCmdlet.ShouldProcess(
                    $pathValue
                )
                if ($shouldProcess) {
                    if ($null -ne $destinationInfo) {
                        $leaf = Split-Path -Path $pathValue -Leaf
                        $destinationPath = $WinSCPSession.CombinePaths(
                            $Destination, $leaf
                        )
                    }

                    if (( Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $destinationPath ) -and $Force.IsPresent) {
                        Remove-WinSCPItem -WinSCPSession $WinSCPSession -Path $destinationPath -Confirm:$false
                    }

                    $WinSCPSession.DuplicateFile(
                        $pathValue, $destinationPath
                    )
                }

                if ($PassThru.IsPresent) {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $destinationPath
                }
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }
}
