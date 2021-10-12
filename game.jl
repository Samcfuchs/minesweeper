module Minesweeper

using Random: shuffle
using PaddedViews: PaddedView

export make_board, request, Index

Minefield = Array{Bool}
Index = CartesianIndex{2}

# Make a board with random mine positions
function make_board(h::Int,w::Int,n=0)::Minefield
    @assert n <= h * w

    b = zeros(Bool,(h,w))
    b[1:n] .= 1.0
    shuffle(b)
end

function neighbors(board::Minefield, ix::Index)::Int
    filt = ones(3,3)
    filt[2,2] = 0
    one = Index(1,1)

    pad = PaddedView( 0, board, (0:size(board,1)+1, 0:size(board,2)+1) )
    neighborhood = pad[ ix-one : ix+one ]

    sum(neighborhood .* filt)
end

function request(board::Minefield, ix::Tuple)::Int
    ix = Index(ix)
    if board[ix]
        # Game over
        return -1
    else
        return neighbors(board, ix)
    end
end

"""
Submit a grid of flags to check if the player has identified all the mines
correctly. Returns 1 if correct, and -1 if any mine is misidentified. In either
case, the game should end--with a win if correct and a failure if incorrect, so
that clients cannot repeatedly guess different configurations.
"""
function submit(board::Minefield, flags::Array{Bool})
    if all(board .== flags)
        return 1
    else
        # Game over
        return -1
    end
end
