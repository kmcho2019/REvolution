module TopModule(
    input  [5:0] y,
    input         w,
    output        Y1,
    output        Y3
);

// Y1 is the input to the state flip-flop y[1], which corresponds to state B.
// State B is the next state when the current state is A and w = 1.
assign Y1 = (y[0] && w);

// Y3 is the input to the state flip-flop y[3], which corresponds to state D.
// State D is the next state when the current state is B and w = 0, 
// or when the current state is C and w = 0, 
// or when the current state is E and w = 0, 
// or when the current state is F and w = 0.
assign Y3 = (~w && (y[1] || y[2] || y[4] || y[5]));

endmodule