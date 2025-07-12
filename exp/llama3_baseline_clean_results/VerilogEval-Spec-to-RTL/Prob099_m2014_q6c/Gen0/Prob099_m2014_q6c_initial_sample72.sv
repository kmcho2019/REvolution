module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 (y[0]) is 1 when current state is A (y = 000001) and w is 0, 
    // or when current state is D (y = 001000) and w is 0
    assign Y1 = (~w & (y[0] | y[3]));

    // Y3 (y[2]) is 1 when current state is C (y = 000100) and w is 0, 
    // or when current state is F (y = 100000) and w is 0
    assign Y3 = (~w & (y[2] | y[5]));

endmodule