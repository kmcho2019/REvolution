module TopModule(
    input  [5:0] y,  // current state
    input        w,  // input
    output       Y1, // input of state flip-flop y[1]
    output       Y3  // input of state flip-flop y[3]
);

// Y1 is 1 when the next state is B
// This happens when current state is A and w is 0
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0]) & ~w;

// Y3 is 1 when the next state is D
// This happens from B when w is 0, from C when w is 0, from E when w is 0, 
// from F when w is 0, and from D when w is 0
assign Y3 = ((~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) | 
            (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0]) | 
            (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) | 
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) | 
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0])) & ~w;

endmodule