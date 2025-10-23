module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = ~w & y[0]; // Y1 is high when current state is A and w is 0
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]) | ~w & y[3]; // Y3 is high when current state is B, C, E, or F and w is 1, or when current state is D and w is 0

endmodule