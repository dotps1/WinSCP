#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Get-WinSCPSession" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
            Stop-Process -Force
    }
    
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPSession.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPSession.ps1"
        }
        
        It "Invoke-ScriptAnalyzer of Get-WinSCPSession results count should be 0." {
            $results.Count | 
                Should -Be 0
        }
    }
}
