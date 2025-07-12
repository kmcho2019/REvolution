module TopModule(
    input [5:0] y, // current state
    input w,      // input
    output Y1,    // next-state signal y[0]
    output Y2,    // next-state signal y[1]
    output Y3,    // next-state signal y[2]
    output Y4     // next-state signal y[3]
);

// State A (y[0] = 1)
assign Y1 = (~w & y[0]) | (~w & y[3]);

// State B (y[1] = 1)
assign Y2 = (~w & y[0]) | (~w & y[5]);

// State C (y[2] = 1)
assign Y3 = (~w & y[1]);

// State D (y[3] = 1)
assign Y4 = (w & y[1]) | (w & y[2]) | (w & y[4]) | (w & y[3]);

endmodule