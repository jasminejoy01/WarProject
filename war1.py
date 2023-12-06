class War:
    def __init__(self):
        self.p1_hand = []
        self.p2_hand = []
        self.current_hand_list = []

    def p1_p2(self):
        self.p1_hand = self.p1_hand + self.current_hand_list
        self.current_hand_list=[]
        
        print("-------------------")
        print(f"p1 hand: {self.p1_hand}")
        print(f"p2 hand: {self.p2_hand}")
        print("-------------------")
        
    def p2_p1(self):
        self.p2_hand = self.p2_hand + self.current_hand_list
        self.current_hand_list=[]

        print("-------------------")
        print(f"p1 hand: {self.p1_hand}")
        print(f"p2 hand: {self.p2_hand}")
        print("-------------------")


    def tie(self):
        tie_blind_pull_p1 = self.p1_hand.pop(0)
        tie_blind_pull_p2 = self.p2_hand.pop(0)
        self.current_hand_list = self.current_hand_list + [tie_blind_pull_p1]
        self.current_hand_list = self.current_hand_list + [tie_blind_pull_p2]
        War.pull_card(self)
        
    def pull_card(self):
        print("-------------------")
        print(f"p1 hand: {self.p1_hand}")
        print(f"p2 hand: {self.p2_hand}")
        print("-------------------")

        card_up_p1 = self.p1_hand.pop(0)
        card_up_p2 = self.p2_hand.pop(0)

        War.driver(self, card_up_p1, card_up_p2)

    def check_len_of_hands(self):

        while len(self.p1_hand) >=1 and len(self.p2_hand) >=1:
            War.pull_card(self)

    def driver(self, card_up_p1, card_up_p2):
        
        if len(self.current_hand_list) >=1: 
            self.current_hand_list = self.current_hand_list + [card_up_p1]
            self.current_hand_list = self.current_hand_list + [card_up_p2]
        else:
            self.current_hand_list = [card_up_p1]
            self.current_hand_list = self.current_hand_list + [card_up_p2]
        self.current_hand_list.sort(reverse=True)
        if card_up_p1 > card_up_p2:
            War.p1_p2(self)
        elif card_up_p2 > card_up_p1:
            War.p2_p1(self)
        elif card_up_p1 == card_up_p2:
            War.tie(self)
    def split_alternatively(self, t20):

        for i, element in enumerate(t20):
            if i % 2 == 0:
                self.p1_hand.append(element)
            else:
                self.p2_hand.append(element)

t20= [14,2,3,4,5,6,7,8,9,10,11,12,14,2,3,4,5,6,7,8,9,10,11,12,14,2,3,4,5,6,7,8,9,10,11,12,14,2,3,4,5,6,7,8,9,10,11,12,13,13,13,13]
r20 = [5,2,9,6,1,6,11,4,10,5,9,3,13,5,11,3,1,4,12,2,7,2,3,2,1,13,13,11,10,10,13,12,12,9,7,4,1,7,10,4,11,5,6,3,12,9,8,8,8,8,7,6]
init = War()
init.split_alternatively(t20)
init.check_len_of_hands()