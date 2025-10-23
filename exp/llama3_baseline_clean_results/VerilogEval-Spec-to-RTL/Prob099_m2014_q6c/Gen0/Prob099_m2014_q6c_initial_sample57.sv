module TopModule(
    input  [5:0] y,  // current state
    input  w,      // input signal
    output Y1,     // next-state signal for y[0]
    output Y3      // next-state signal for y[2]
);

// Next-state logic for Y1 (y[0])
assign Y1 = (y[5] & w) | (y[3] & ~w);  // transition to B from A or D

// Next-state logic for Y3 (y[2])
assign Y3 = (y[4] & w) | (y[1] & ~w);  // transition to C from B or E

endmodule