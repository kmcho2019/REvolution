module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 corresponds to next state B: y[1]
assign Y1 = y[0] & (~w);

// Y3 corresponds to next state D: y[3]
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule