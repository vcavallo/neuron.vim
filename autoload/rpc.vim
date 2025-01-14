func! s:on_exit(chan_id, code, ...) abort
	let g:neuron_rib_job = -1
endf

func! rpc#start_server()
	let options = {
		\ 'err_mode': 'nl',
		\ 'out_mode': 'nl',
		\ 'exit_cb': function('s:on_exit'),
		\}
	if g:neuron_rib_job == -1
		let g:neuron_rib_job = jobstart(['neuron', 'rib', '-wS'], options)
		echom 'Neuron rib server started.'
	end
	echom 'Opening http://127.0.0.1:8080/...'
	call rpc#open_preview_page()
endf

func! rpc#stop_server()
	if g:neuron_rib_job != -1
		call jobstop(g:neuron_rib_job)
		echom('Neuron rib server stopped.')
		let g:neuron_rib_job = -1
	else
		echom 'Neuron rib server is not running already!'
	end
endf

func! rpc#open_preview_page()
	let l:opener = {'linux': 'xdg-open', 'macos': 'open'}
	let l:platform = util#get_platform()
	let l:current_buffer = expand('%:t:r')
	if util#is_current_buf_zettel()
		let l:url = 'http://127.0.0.1:8080/'.l:current_buffer.'.html'
	else
		let l:url = 'http://127.0.0.1:8080/'
	end
		silent exec ":!".l:opener[l:platform]." '".l:url."'"
endf
