include("./game.jl")

H = 16
W = 16
N = 20

module Client

Tile = Union{Int, Char}

board = Minesweeper.make_board(H, W, N)

info = Array{Tile, 2}(undef, H, W)
info .= '?'

function printinfo(arr)
    r,c = size(arr)

    println(" "^3, join([lpad(i, 3) for i in 1:c]))
    println(" "^5, "   "^c)
    #println("    ", join(1:c, " "))
    for i in 1:r
        print(lpad(i, 2), " - ")
        print(join(arr[i,:], "  "))
        println()
    end
end

function explorezero(r,c)
    k = info[r,c]
    if k == '?'
        ct = Minesweeper.request(board, (r,c))
        if ct != 0
            info[r,c] = ct
            return
        end

        info[r,c] = ' '

        for i in max(1, r-1):min(H, r+1)
            for j in max(1, c-1):min(W, c+1)
                explorezero(i,j)
            end
        end
    end
end



while true
    printinfo(info)
    println()

    input = split(readline())
    command = input[1]

    if command == "quit"
        break
    end

    r = parse(Int, input[2])
    c = parse(Int, input[3])

    if command == "flag"
        info[r,c] = 'X'
    end

    if command == "unflag"
        info[r,c] = '?'
    end

    if command == "try"
        if info[r,c] == 'X'
            println("That tile is flagged!")
            continue
        end

        result = Minesweeper.request(board, (r,c))

        if result == -1
            println("You hit a mine")
            break
        end

        if result == 0
            explorezero(r,c)
        else
            info[r,c] = result
        end
    end

end

end
