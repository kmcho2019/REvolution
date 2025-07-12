module TopModule(
    input  [5:0] y,  // current state
    input  w,      // input
    output Y1,     // next state bit y[0]
    output Y3      // next state bit y[2]
);

// Logic equations for next-state signals Y1 and Y3
assign Y1 = (y[0] & ~w) | (y[3] & ~w);
assign Y3 = (y[1] & ~w) | (y[4] & w) | (y[5] & ~w);

endmodule