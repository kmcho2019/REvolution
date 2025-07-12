module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = (y[0] && w); // Next state is B (000010) when current state is A (000001) and w = 1

assign Y3 = ((y[1] && !w) || (y[2] && !w) || (y[3] && !w) || (y[4] && !w)); // Next state is D (001000) when current state is B, C, D, or E and w = 0

endmodule