module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A ... y[5]=F
    input        w,
    output       Y1,  // Next state B (y[1])
    output       Y3   // Next state D (y[3])
);

assign Y1 = y[0] & ~w;
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule