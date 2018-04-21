function! Gallery()
    let win_state = winsaveview()
    let paths = globpath(&rtp, "colors/*.vim", 0, 1)

    let names = map(paths, { index, value -> fnamemodify(value, ':t:r') })
    call sort(names)
    if exists("g:colors_name")
        let old_name = g:colors_name
    else
        let old_name = "default"
    endif
    let index = index(names, old_name)
    if index < 0
        let index = 0
    endif
    let name = names[index % len(names)]
    execute 'colorscheme' name
    redraw
 
    while v:true
        let help_prompt = "[?] Show Help"
        let prompt_start = printf('%d/%d: %s', index + 1, len(names), name)
        let remaining_length = &columns - len(prompt_start) - 1
        echon prompt_start printf("%" . remaining_length . "s", help_prompt)
        let key = getchar()
        let option = nr2char(key)

        if option ==? 'j'
            let index += 1
        elseif option ==? 'k'
            let index -= 1
        elseif option ==? "\<Enter>"
            redraw
            echo 'Accepted' name '(remember to update your config)'
            break
        elseif option ==? 'q' || option ==? "\<Esc>"
            execute 'colorscheme' old_name
            redraw
            echo 'Canceled'
            break
        elseif option ==? '?'
            execute 'colorscheme' old_name
            redraw
            execute 'help gallery.txt'
            break
        endif
 
        let index = (index + len(names)) % len(names)
        let name = names[index]
        execute 'colorscheme ' . name
        redraw
    endwhile
    call winrestview(win_state)
endfunction
