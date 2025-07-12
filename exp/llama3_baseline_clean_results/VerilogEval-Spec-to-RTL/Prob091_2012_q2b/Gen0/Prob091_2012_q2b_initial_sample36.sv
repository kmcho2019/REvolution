module TopModule(
    input  [5:0] y,  // Current state
    input  w,      // Input to determine next state
    output Y1,     // Input to state flip-flop y[1]
    output Y3      // Input to state flip-flop y[3]
);

// Logic for Y1 (y[1] input) is '1' when in states B or D
assign Y1 = y[1] | (y[3] & ~w); // Since y[1] is directly '1' in state B, and for D, it's y[3] with w=0

// Logic for Y3 (y[3] input) is '1' when in state D
assign Y3 = y[3]; // Directly assign since Y3 is '1' only in state D

endmodule