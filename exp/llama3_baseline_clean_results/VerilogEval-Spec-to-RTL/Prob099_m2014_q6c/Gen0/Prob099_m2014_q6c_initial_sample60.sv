module TopModule(
    input [5:0] y,  // current state
    input w,      // input
    output Y1,    // next state y[0]
    output Y3     // next state y[3]
);

// next-state logic for Y2 (y[1])
// Y2 will be 1 if current state is A and 'w' is 0
// or if current state is B and 'w' is 1
assign Y2 = (y[0] && !w) || (y[1] && w);

// next-state logic for Y4 (y[3])
// Y4 will be 1 if current state is B, C, E, or D and 'w' is 1
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[3] && w);

// next-state logic for Y1 (y[0])
// Y1 will be 1 if current state is D and 'w' is 0
assign Y1 = (y[3] && !w);

endmodule