reg_machine: rom.v dff.v timer.v processor.v reg_machine.v reg_machine_test.v
	iverilog -o reg_machine_test rom.v dff.v timer.v processor.v reg_machine.v reg_machine_test.v
	./reg_machine_test
	gtkwave reg_machine_test.vcd
	
timer: dff.v timer.v timer_test.v
	iverilog -o timer_test dff.v timer.v timer_test.v
	./timer_test
	gtkwave timer_test.vcd

processor: dff.v timer.v processor.v processor_test.v
	iverilog -o processor_test dff.v timer.v processor.v processor_test.v
	./processor_test
	gtkwave processor_test.vcd
	
rom: rom.v rom_test.v
	iverilog -o rom_test rom.v rom_test.v
	./rom_test
	gtkwave rom_test.vcd