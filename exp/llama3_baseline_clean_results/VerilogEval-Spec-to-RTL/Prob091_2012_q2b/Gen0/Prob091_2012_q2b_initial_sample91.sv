module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is set if the current or next state has y[1] = 1
// This happens in states B and D
assign Y1 = (y[1] &&!w) ||  // Current state is B and w is 0, or
           (y[0] && w) ||   // Current state is A and w is 1, going to B
           (y[3] &&!w);    // Current state is D and w is 0

// Y3 is set if the current or next state has y[3] = 1
// This happens in state D
assign Y3 = (y[3]);         // Current state is D

endmodule