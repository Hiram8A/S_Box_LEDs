onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /AES_SBox_tb/CLOCK_50
add wave -noupdate -expand /AES_SBox_tb/SW
add wave -noupdate /AES_SBox_tb/KEY
add wave -noupdate -expand /AES_SBox_tb/LEDR
add wave -noupdate -expand /AES_SBox_tb/test_data
add wave -noupdate -expand /AES_SBox_tb/encrypted_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {286 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 175
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {90 ps} {803 ps}
