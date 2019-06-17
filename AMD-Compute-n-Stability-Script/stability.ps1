# Original script by lordpurvis (https://www.reddit.com/user/lordpurvis) from https://www.reddit.com/r/gpumining/comments/7uuw5f/automatically_setting_amd_cards_from_graphics_to/
# Modified by phila82r (https://anorak.tech/u/phila82r - https://twitter.com/phila82r)
# Show your appreciation by sending donations to 0xf7c0737a32ad2b971e74478D61B0Ed193097Cf82
# Latest script version will always be available through the Anorak.Tech Forums https://anorak.tech/c/mining-hardware-software-tools

######################################
# AMD CFAL & ULPS Toggle Script v2.0 #
######################################
# Set version number and script name
$version = "2.0"
$script_name = "AMD CFAL & ULPS Toggle Script"

# Setting all variables to 0
$device_count = 0
$amd_count = 0
$notamd_count = 0
$change_success = 0
$change_fail = 0
$change_total = 0

$cfal_current_value = $null
$cfal_new_value = $null
$ulps_current_value = $null
$ulps_new_value = $null

# Let the user know the script has started
Write-Host "`n $script_name" -NoNewline -ForegroundColor DarkRed
Write-Host " v$version" -ForegroundColor DarkYellow
Write-Host "`n Original script by lordpurvis, modified by phila82r. For more info, check the source of this script.`n Send your love to 0xf7c0737a32ad2b971e74478D61B0Ed193097Cf82.`n"

Write-Host " This script allows you to toggle 2 registry settings on/off for all of your installed AMD GPUs:"
Write-Host "   CFAL or CrossFireAutoLink" -NoNewline -ForegroundColor DarkMagenta
Write-Host " should be DISABLED for mining (adds stability)."
Write-Host "   ULPS or UltraLowPowerState" -NoNewline -ForegroundColor DarkMagenta
Write-Host " should be DISABLED for mining (adds stability)."

Write-Host "`n Let's get started...`n" -ForegroundColor Green

Write-Host " Choose between:"
Write-Host " (1) Turn OFF  CFAL & ULPS - Adds stability to AMD GPUs while mining"
Write-Host " (2) Turn ON   CFAL & ULPS - Back to default registry settings"
Write-Host " (9) Check the CFAL & ULPS status of all AMD GPUs`n (X) Any other selection will exit the script`n"

$choice = Read-Host " Make a choice and press ENTER"

Switch ($choice) {

	# If the user chooses option 1, then let's optimize for mining
	1 {
		Write-Host "`n Great, let's optimize for mining"
		Do {
			# Change $device_count value to use the 0000 format in regedit
			$device_count_string = $device_count.ToString("0000")
			$device_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$device_count_string\"
			$device_key = Get-Item -LiteralPath $device_path -ErrorAction SilentlyContinue

			if ($device_key) {
				$device_value = $device_key.GetValue("ProviderName", $null)

				# Check if the ProviderName is AMD
				if ($device_value -eq "Advanced Micro Devices, Inc.") {
					# Send a message to the user
					Write-Host "`n	GPU #" -NoNewline
					Write-Host "$device_count" -NoNewline -ForegroundColor DarkYellow
					Write-Host " is " -NoNewline
					Write-Host "AMD" -NoNewline -ForegroundColor DarkRed
					Write-Host ", modifying settings..."

					$cfal_current_value = $device_key.GetValue("EnableCrossFireAutoLink", $null)
					if ($cfal_current_value -eq "0") {
						# Already disabled
						Write-Host "	Already disabled, skipping CFAL"
					} else {
						Set-ItemProperty -LiteralPath $device_path -Name "EnableCrossFireAutoLink" -Value 0 -Type DWord
						$cfal_new_value = $device_key.GetValue("EnableCrossFireAutoLink", $null)

						if ($cfal_new_value -eq "0") {
							# Send a success message to the user
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - CFAL is now " -NoNewline
							Write-Host "DISABLED" -ForegroundColor Green

							$change_success += 1
						} else {
							# Send a fail message to the user
							Write-Host "	Failed - Couldn't disable CrossFireAutoLink" -ForegroundColor Red
							Write-Host "	Failed - CrossFireAutoLink value is currently ($cfal_new_value) but should be set to (0) in the registry" -ForegroundColor Red

							$change_fail += 1
						}

						$change_total += 1
					}

					$ulps_current_value = $device_key.GetValue("EnableUlps", $null)
					if ($ulps_current_value -eq "0") {
						# Already disabled
						Write-Host "	Already disabled, skipping ULPS"
					} else {
						Set-ItemProperty -LiteralPath $device_path -Name "EnableUlps" -Value 0 -Type DWord
						$ulps_new_value = $device_key.GetValue("EnableUlps", $null)

						if ($ulps_new_value -eq "0") {
							# Send a success message to the user
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - ULPS is now " -NoNewline
							Write-Host "DISABLED" -ForegroundColor Green

							$change_success += 1
						} else {
							# Send a fail message to the user
							Write-Host "	Failed - Couldn't disable UltraLowPowerState" -ForegroundColor Red
							Write-Host "	Failed - UltraLowPowerState value is currently ($ulps_new_value) but should be set to (0) in the registry" -ForegroundColor Red

							$change_fail += 1
						}

						$change_total += 1
					}

					# Send a message to the user
					Write-Host "	GPU #" -NoNewline
					Write-Host "$device_count" -NoNewline -ForegroundColor DarkYellow
					Write-Host " is " -NoNewline
					Write-Host "SET FOR MINING" -ForegroundColor Green

					# +1 to the amd counter, total will be displayed at the end of the script
					$amd_count += 1

				# If ProviderName is not AMD, then do this
				} else {
					# Let the user know we found a device, but it's not from AMD
					Write-Host "`n	GPU #$device_count is $device_value, no mods needed!" -ForegroundColor DarkGreen
					# +1 to the notamd counter, total will be displayed at the end of the script
					$notamd_count += 1
				}
			}

			$device_count += 1

		# If $device_count is 51 or more (-lt 50), most likely all devices have been checked
		} While ($device_count -lt 50)
	} # END OPTION 1

	# If the user chooses option 2, then let's revert back to the default registry values
	2 {
		Write-Host "`n Alright, let's reset all the registry settings back to their default values"

		Do {
			# Change $device_count value to use the 0000 format in regedit
			$device_count_string = $device_count.ToString("0000")
			# Set the path to the device in a variable
			$device_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$device_count_string\"
			# Get the device key
			$device_key = Get-Item -LiteralPath $device_path -ErrorAction SilentlyContinue

			if ($device_key) {
				# Store the ProviderName in a variable
				$device_value = $device_key.GetValue("ProviderName", $null)

				# Check if the ProviderName is AMD
				if ($device_value -eq "Advanced Micro Devices, Inc.") {
					# Send a message to the user
					Write-Host "`n	GPU #" -NoNewline
					Write-Host "$device_count" -NoNewline -ForegroundColor DarkYellow
					Write-Host " is " -NoNewline
					Write-Host "AMD" -NoNewline -ForegroundColor DarkRed
					Write-Host ", modifying settings..."

					$cfal_current_value = $device_key.GetValue("EnableCrossFireAutoLink", $null)

					if ($cfal_current_value -eq "1") {
						# Already disabled
						Write-Host "	Already enabled, skipping CFAL"
					} else {
						Set-ItemProperty -LiteralPath $device_path -Name "EnableCrossFireAutoLink" -Value 1 -Type DWord
						$cfal_new_value = $device_key.GetValue("EnableCrossFireAutoLink", $null)

						if ($cfal_new_value -eq "1") {
							# Send a success message to the user
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - CFAL is now " -NoNewline
							Write-Host "ENABLED" -ForegroundColor DarkMagenta

							$change_success += 1
						} else {
							# Send a fail message to the user
							Write-Host " Failed - Couldn't enable CrossFireAutoLink" -ForegroundColor Red
							Write-Host " Failed - CrossFireAutoLink value is currently ($cfal_new_value) but should be set to (1) in the registry" -ForegroundColor Red

							$change_fail += 1
						}

						$change_total += 1
					}

					$ulps_current_value = $device_key.GetValue("EnableUlps", $null)
					if ($ulps_current_value -eq "1") {
						# Already disabled
						Write-Host "	Already enabled, skipping ULPS"
					} else {
						Set-ItemProperty -LiteralPath $device_path -Name "EnableUlps" -Value 1 -Type DWord
						$ulps_new_value = $device_key.GetValue("EnableUlps", $null)

						if ($ulps_new_value -eq "1") {
							# Send a success message to the user
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - ULPS is now " -NoNewline
							Write-Host "ENABLED" -ForegroundColor DarkMagenta

							$change_success += 1
						} else {
							# Send a fail message to the user
							Write-Host "	Failed - Couldn't enable UltraLowPowerState" -ForegroundColor Red
							Write-Host "	Failed - UltraLowPowerState value is currently ($ulps_new_value) but should be set to (1) in the registry" -ForegroundColor Red

							$change_fail += 1
						}

						$change_total += 1
					}

					# Send a message to the user
					Write-Host "	GPU #" -NoNewline
					Write-Host "$device_count" -NoNewline -ForegroundColor DarkYellow
					Write-Host " is " -NoNewline
					Write-Host "SET TO DEFAULT" -ForegroundColor DarkMagenta

					# +1 to the amd counter, total will be displayed at the end of the script
					$amd_count += 1

				# If ProviderName is not AMD, then do this
				} else {
					# Let the user know we found a device, but it's not from AMD
					Write-Host "`n	GPU #$device_count is $device_value, no mods needed!" -ForegroundColor DarkGreen
					# +1 to the notamd counter, total will be displayed at the end of the script
					$notamd_count += 1
				}
			}

			$device_count += 1

		# If $device_count is 51 or more (-lt 50), most likely all devices have been checked
		} While ($device_count -lt 50)
	} # END OPTION 2

	# If the user chooses option 9, then let's list the registry values without making any changes
	9 {
		Write-Host "`n Incoming status..."

		Do {
			# Change $device_count value to use the 0000 format in regedit
			$device_count_string = $device_count.ToString("0000")
			$device_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$device_count_string\"
			$device_key = Get-Item -LiteralPath $device_path -ErrorAction SilentlyContinue

			if ($device_key) {
				# Store the ProviderName in a variable
				$device_value = $device_key.GetValue("ProviderName", $null)

				# Check if the ProviderName is AMD
				if ($device_value -eq "Advanced Micro Devices, Inc.") {
					# Send a message to the user
					Write-Host "`n	GPU #" -NoNewline
					Write-Host "$device_count" -NoNewline -ForegroundColor DarkYellow
					Write-Host " is " -NoNewline
					Write-Host "AMD" -NoNewline -ForegroundColor DarkRed
					Write-Host ", checking status..."

					$cfal_current_value = $device_key.GetValue("EnableCrossFireAutoLink", $null)

					Switch ($cfal_current_value) {
						0 {
							# 0 means it is disabled
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - CFAL " -NoNewline
							Write-Host "DISABLED (optimized for mining)" -ForegroundColor Green
						}
						1 {
							# 1 means it is enabled
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - CFAL " -NoNewline
							Write-Host "ENABLED (not mining friendly)" -ForegroundColor DarkMagenta
						}
						default {
							# else means the user should look at the registry because it has a value that is not 0 or 1
							Write-Host "	Oops - CrossFireAutoLink value is set to ($cfal_value), which is not supported by this script" -ForegroundColor Red
						}
					}

					$ulps_current_value = $device_key.GetValue("EnableUlps", $null)

					Switch ($ulps_current_value) {
						0 {
							# 0 means it is disabled
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - ULPS " -NoNewline
							Write-Host "DISABLED (optimized for mining)" -ForegroundColor Green
						}
						1 {
							# 1 means it is enabled
							Write-Host "	GPU #" -NoNewline
							Write-Host "$device_count MOD" -NoNewline -ForegroundColor DarkYellow
							Write-Host " - ULPS " -NoNewline
							Write-Host "ENABLED (not mining friendly)" -ForegroundColor DarkMagenta
						}
						default {
							# else means the user should look at the registry because it has a value that is not 0 or 1
							Write-Host "	Oops - UltraLowPowerState value is set to ($ulps_value), which is not supported by this script" -ForegroundColor Red
						}
					}

					# +1 to the amd counter, total will be displayed at the end of the script
					$amd_count += 1

				# If ProviderName is not AMD, then do this
				} else {
					# Let the user know we found a device, but it's not from AMD
					Write-Host "`n	GPU #$device_count is $device_value, no status available!" -ForegroundColor DarkGreen
					# +1 to the notamd counter, total will be displayed at the end of the script
					$notamd_count += 1
				}
			}

			$device_count += 1

		# If $device_count is 51 or more (-lt 50), most likely all devices have been checked
		} While ($device_count -lt 50)
	} # END OPTION 9

	default {
		Write-Host " Oops, looks like option ($choice) is not a valid option. It might be because of FFS (Fat Fingers Syndrome ;)`n Available options are 1, 2, or 9 - Exiting script for now...`n" -ForegroundColor Red
		Return
	}
}

# Let the user know the total of checked GPUs, how many were AMD or not AMD
Write-Host "`n Out of a total of $device_count checks, we found $amd_count " -NoNewline
Write-Host "AMD" -NoNewline -ForegroundColor DarkRed
Write-Host " GPU(s)."

if (($choice -eq "1") -or ($choice -eq "2")) {
	# Send a message to the user
	if ($change_total -gt 0) {
		Write-Host " -> $change_total changes were made to your registry; " -NoNewline 
		Write-Host "$change_success" -NoNewline -ForegroundColor Green
		Write-Host " succeeded and " -NoNewline 
		Write-Host "$change_fail" -NoNewline -ForegroundColor DarkRed
		Write-Host " failed."
		Write-Host " RESTART YOUR PC FOR THE NEW REGISTRY SETTINGS TO BE APPLIED`n" -ForegroundColor DarkYellow
	} else {
		Write-Host " -> No changes were made, all AMD GPUs are already optimized for mining.`n"
		Write-Host " Press any key to exit this script...`n"

		# Wait for a key press to exit the script
		[void][System.Console]::ReadKey($true)
	}
} else {
	Write-Host " Press any key to exit this script...`n"

	# Wait for a key press to exit the script
	[void][System.Console]::ReadKey($true)
}