module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next-state signal Y2 (corresponding to y[1])
// Y2 will be 1 when the next state is B, D, or F
assign Y2 = (~w & (y[0] | y[1] | y[5])) | (w & (y[1] | y[3] | y[5]));

// Next-state signal Y4 (corresponding to y[3])
// Y4 will be 1 when the next state is D
assign Y4 = (~w & (y[1] | y[2] | y[4] | y[5])) | (w & (y[3]));

// Output signals Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[2];

endmodule