import numpy as np

class Minesweeper(object):

    def __init__(self, h, w, n):
        self.H = h
        self.W = w
        self.N = n

        self.board = self.make_board(h, w, n)
        self.game_over = False

    def make_board(self, h, w, n):
        vals = np.zeros(h * w, dtype=int)
        vals[:n] = 1
        # This runs in-place
        np.random.shuffle(vals)
        return vals.reshape((h,w))

    def get_neighbors(self, x, y):
        filt = np.ones((3,3))
        filt[1,1] = 0
        pad = np.pad(self.board,1)
        xypd = (x+1,y+1)
        tlpd = (x,y)
        brpd = (x+2,y+2)
        neighbors = (pad[x:x+3, y:y+3] * filt).sum() 

        return neighbors

    def request(self, r, c):
        if self.board[(r,c)] == 1:
            self.game_over = True
            print("Game over")
            return -1

        return self.get_neighbors(r, c)
    
    def submit(self, mask):
        if (mask == self.board).all():
            game_over = True
            print("You win")
            return 1
        else:
            game_over = True
            print("Loser")
            return -1
