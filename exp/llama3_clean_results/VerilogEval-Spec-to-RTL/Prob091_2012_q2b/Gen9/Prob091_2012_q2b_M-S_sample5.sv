module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly compute the value of Y1
    assign Y1 = w & y[0]; // State B can be reached from state A when w is 1

    // Directly compute the value of Y3
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // State D can be reached from states B, C, E, F when w is 0

endmodule