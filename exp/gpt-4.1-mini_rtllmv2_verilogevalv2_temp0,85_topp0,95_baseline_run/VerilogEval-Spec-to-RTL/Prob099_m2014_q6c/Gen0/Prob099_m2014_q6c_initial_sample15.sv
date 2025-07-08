module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Derive next-state signals for y[1] and y[3]

// Y1 is next y[1] = y[0] & ~w (A and w=0)
assign Y1 = y[0] & (~w);

// Y3 is next y[3] = (y[1] | y[2] | y[4] | y[5]) & w
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule