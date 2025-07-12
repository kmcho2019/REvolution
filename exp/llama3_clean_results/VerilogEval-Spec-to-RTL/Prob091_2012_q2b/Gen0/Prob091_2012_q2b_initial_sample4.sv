module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 when the FSM is in A and w is 0, or when it is already in B and w is 0
assign Y1 = (~w & (y[0] | y[1]));

// Y3 is 1 when the FSM is in B and w is 0, or in C and w is 0, or in D and w is 1, or in E and w is 0
assign Y3 = (~w & (y[1] | y[2] | y[4])) | (w & y[3]);

endmodule