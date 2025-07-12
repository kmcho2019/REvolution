module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next state B (y[1]) occurs from A (y[0]) when w=0
assign Y1 = y[0] & (~w);

// Next state D (y[3]) occurs from B, C, E, F when w=1
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule