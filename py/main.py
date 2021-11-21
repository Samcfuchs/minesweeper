from game import Minesweeper
import numpy as np

class TUI(object):

    def __init__(self, game):
        self.info = np.repeat(' ', game.H * game.W).reshape((game.H,game.W))
        self.game = game

    def show(self):
        print("Mines remaining:", self.game.N - (self.info == "X").sum())
        for row in self.info:
            print(' '.join(row))
        #print(self.info)
    

    def explore_0(self, r, c):
        for r_ in range(r-1,r+2):
            if r_ < 0 or r_ >= self.game.W:
                continue
            for c_ in range(c-1,c+2):
                if c_ < 0 or c_ >= self.game.H:
                    continue

                if self.info[r_,c_] != ' ':
                    continue

                ct = self.game.request(r_,c_)
                self.info[r_,c_] = ct
                if ct == 0:
                    self.explore_0(r_,c_)
    
    def get_input(self):
        while True:
            response = input("Command: ")
            response = response.strip().split(' ')
            response = [w for w in response if w != '']
            cmd = response[0]
            info = self.info

            if cmd == "quit":
                return -1

            if cmd == "submit":
                self.game.submit(self.info == "X")
                return 0
            
            r = int(response[1])
            c = int(response[2])

            if cmd == "flag":
                info[r,c] = "X"
                return 0
            
            if cmd == "unflag":
                info[r,c] = '?'
                return 0
            
            if cmd == "try":
                if self.info[r,c] == 'X':
                    print("That tile is flagged!")
                    continue
                    
                result = self.game.request(r,c)
                #print("result:", result)

                if result == -1:
                    print("Aw shucks")
                    return -1
                
                if result == 0:
                    info[r,c] = result
                    self.explore_0(r, c)
                    return 0
                    pass
                    # explore this...

                self.info[r,c] = result
                return 0

if __name__ == '__main__':
    g = Minesweeper(8, 8, 2)
    p = TUI(g)

    while g.game_over == False:
        p.show()
        print()
        r = p.get_input()
        if r == -1:
            break
        
