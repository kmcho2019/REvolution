module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is 1 when the next state is B, which happens when current state is A and w is 1
assign Y1 = y[0] && w;

// Y3 is 1 when the next state is D, which can happen from B, C, or E when w is 0
assign Y3 = (y[1] || y[2] || y[4]) && !w;

endmodule