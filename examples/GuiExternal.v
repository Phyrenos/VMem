import ui

import vmem

const win_width = 450
const win_height = 250

@[heap]
struct App {
mut:
	window         &ui.Window = unsafe { nil }
	current_ammo_label &ui.Label = unsafe { nil }
	current_ammo 	   u16

	infiniteammo_label &ui.Label = unsafe { nil }
	infiniteammo bool

	h_process u32
	process_id u32
}

fn (mut app App) hacks() {
	
		//address := voidptr(0x007541D0)
		address := voidptr(0x007A3F28)
		new_value := u32(25555) 
		for {
			app.current_ammo = vmem.read_memory(app.h_process, address)[0]
			app.current_ammo_label.set_text('Current Ammo: ${app.current_ammo}')
			app.infiniteammo_label.set_text('Infinite Ammo: ${app.infiniteammo}')
			if vmem.read_memory(app.h_process, address)[0] != 25555 {
				if app.infiniteammo {
					if vmem.write_memory(app.h_process, address, new_value) {
					//	println('Successfully wrote new value: ${new_value}')
					} else {
						println('Failed to write memory. Error code: ${C.GetLastError()}')
					}
				}
			}
		}
	
}

fn main() {

	mut app := &App{}
	window_name := 'AssaultCube'
	app.infiniteammo = false

	app.process_id = vmem.get_process_id_from_window_name(window_name) or {
		println(err)
		return
	}
	app.h_process = vmem.get_hprocess(app.process_id) or {
		println(err)
		return
	}

	app.current_ammo_label = ui.label(text: 'Current Ammo: ${app.current_ammo}')
	app.infiniteammo_label = ui.label(text: 'Infinite Ammo: ${app.infiniteammo}')
	app.window = ui.window(
		width:    win_width
		height:   win_height
		title:    'AssaultCube Cheat'
		children: [
			ui.column(
				spacing: 20
				margin:  ui.Margin{30, 30, 30, 30}
				children: [
					ui.label(text: 'Process ID: ${app.process_id}'),
					ui.label(text: 'Process ID: ${app.h_process}'),
					app.current_ammo_label,
					app.infiniteammo_label,
					ui.button(text: 'Infinite Ammo', on_click: app.btn_infinite_ammo, width: 150),
					
				]
			),
		]
	)
	spawn app.hacks()
	ui.run(app.window)

	
}

fn (mut app App) btn_infinite_ammo(btn &ui.Button) {

	app.infiniteammo = !app.infiniteammo
	
	println('Infinite Ammo: ${app.infiniteammo}')
}