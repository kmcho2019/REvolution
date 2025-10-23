module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input to the FSM
    output       Y1, // Input to state flip-flop y[1]
    output       Y3  // Input to state flip-flop y[3]
);

// State B is reached from A when w is 0
assign Y1 = (y[0] == 1'b1) && (w == 1'b0);

// State D is reached from B, C, E, or F when w is 0, and from D when w is 1
assign Y3 = ((y[1] == 1'b1) || (y[2] == 1'b1) || (y[4] == 1'b1) || (y[5] == 1'b1)) && (w == 1'b0) ||
           (y[3] == 1'b1) && (w == 1'b1);

endmodule