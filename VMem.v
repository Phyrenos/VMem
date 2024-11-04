module vmem

#flag -l user32
#flag -l kernel32

fn C.FindWindowA(lpClassName &char, lpWindowName &char) u32
fn C.GetWindowThreadProcessId(hwnd u32, lpdwProcessId &u32) u32
fn C.OpenProcess(dwDesiredAccess u32, bInheritHandle bool, dwProcessId u32) u32
fn C.ReadProcessMemory(hProcess u32, lpBaseAddress voidptr, lpBuffer voidptr, dwSize u32, lpNumberOfBytesRead &u32) bool
fn C.WriteProcessMemory(hProcess u32, lpBaseAddress voidptr, lpBuffer voidptr, dwSize u32, lpNumberOfBytesWritten &u32) bool
fn C.CloseHandle(hObject u32) bool
fn C.GetLastError() u32

const process_access_all = 0x1F0FFF

pub fn get_process_id_from_window_name(window_name string) !u32 {
	hwnd := C.FindWindowA(0, window_name.str)
	if hwnd == 0 {
		return error('Window not found')
	}

	mut pid := u32(0)
	C.GetWindowThreadProcessId(hwnd, &pid)
	return pid
}

pub fn get_hprocess(process_id u32) !u32 {
	return C.OpenProcess(process_access_all, false, process_id)
}

pub fn read_memory(h_process u32, address voidptr) []u16 {
	mut old_value := [u16(0), u16(0)]
	mut bytes_read := u32(0)

	unsafe {
		if C.ReadProcessMemory(h_process, address, &old_value[0], old_value.len, &bytes_read)
			&& bytes_read == old_value.len {
			return old_value
		} else {
			return [u16(0), u16(0)]
		}
	}
}

pub fn write_memory(h_process u32, address voidptr, new_value int) bool {
	mut con_new_value := u32(new_value)
	mut bytes_written := u32(0)
	return C.WriteProcessMemory(h_process, address, &con_new_value, sizeof(con_new_value),&bytes_written)
}
