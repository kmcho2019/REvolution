module TopModule (
    input  [5:0] y,  // one-hot current state encoding: A=000001=y[0], ..., F=100000=y[5]
    input        w,  // input signal
    output       Y1, // next-state signal for B (y[1])
    output       Y3  // next-state signal for D (y[3])
);

// Next state B (y[1]) from:
// A (y[0]) & w=0
assign Y1 = y[0] & (~w);

// Next state D (y[3]) from:
// B (y[1]) & w=1
// C (y[2]) & w=1
// E (y[4]) & w=1
// F (y[5]) & w=1
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule