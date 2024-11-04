
import vmem

fn main() {

	window_name := 'AssaultCube'

	process_id := vmem.get_process_id_from_window_name(window_name) or {
		println(err)
		return
	}
	h_process := vmem.get_hprocess(process_id) or {
		println(err)
		return
	}
	println('Process ID: ${process_id}')
	println('Process ID: ${h_process}')

	address := voidptr(0x007A3F28)
	new_value := u32(25555) 
	for {
		if vmem.read_memory(h_process, address)[0] != new_value {
			if vmem.write_memory(h_process, address, new_value) {
				println('Successfully wrote new value: ${new_value}')
			} else {
				println('Failed to write memory. Error code: ${C.GetLastError()}')
			}
		
		}
	}
}