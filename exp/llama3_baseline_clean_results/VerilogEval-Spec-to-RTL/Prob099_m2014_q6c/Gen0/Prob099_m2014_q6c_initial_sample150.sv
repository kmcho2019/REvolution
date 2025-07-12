module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
    );

    assign Y1 = (y[3] & w) | (y[0] & w);  // Next state for A (y[0]) is 1 when current state is D or A and w = 1
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);  // Next state for C (y[2]) is 1 when current state is B or F and w = 0

endmodule