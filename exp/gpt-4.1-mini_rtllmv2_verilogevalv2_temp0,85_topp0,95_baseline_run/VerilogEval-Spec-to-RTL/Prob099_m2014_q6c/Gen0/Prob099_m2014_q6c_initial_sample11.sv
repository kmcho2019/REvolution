module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is next y[1], Y3 is next y[3]
// From state diagram and one-hot encoding:
// Y1 = y[0] & ~w;  // y[0] is state A, next to B if input=0
// Y3 = (y[1] | y[2] | y[4] | y[5]) & w; // from B,C,E,F with input=1 to D

assign Y1 = y[0] & (~w);
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule