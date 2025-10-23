module TopModule(
    input [2:0] y,  // current state
    input w,
    output Y1  // output y[1]
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b100) | (y == 3'b101) | (y == 3'b110) | (y == 3'b111);

// But since we are only interested in next state logic for y[1], 
// we will consider all possible transitions to states C, D, E, F

// Transition to C (y[1] = 1)
// From B (y = 001), w = 0
// From F (y = 111), w = 0
assign Y1 = ((y == 3'b001) & ~w) | ((y == 3'b111) & ~w) | 
           // Transition to D (y[1] = 1)
           // From B (y = 001), w = 1
           // From C (y = 100), w = 1
           // From E (y = 110), w = 1
           // From F (y = 111), w = 1
           ((y == 3'b001) & w) | ((y == 3'b100) & w) | ((y == 3'b110) & w) | ((y == 3'b111) & w) | 
           // Current state is C, D, E, F
           ((y == 3'b100) | (y == 3'b101) | (y == 3'b110) | (y == 3'b111));

endmodule