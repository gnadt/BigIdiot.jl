function suitor_check(x, d)
    target = (48,true)
    ok = "       ✅"
    sum(d) == target[1] ? println("$ok ∑ digits = $(sum(d))") : nothing
    x      == target[2] ? println("$ok Girl     = 🆒") : nothing
end # function suitor_check
