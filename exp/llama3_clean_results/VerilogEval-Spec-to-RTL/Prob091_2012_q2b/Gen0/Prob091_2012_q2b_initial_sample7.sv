module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Y1 is the input of state flip-flop y[1], which corresponds to state B
    // State B can be reached from state A when w is 0
    assign Y1 = ~w & y[0];  // y[0] represents state A

    // Y3 is the input of state flip-flop y[3], which corresponds to state D
    // State D can be reached from states B, C, E, and F under different input conditions
    assign Y3 = (~w & (y[1] | y[2] | y[4])) | (w & (y[4] | y[5]));

endmodule