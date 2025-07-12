module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly assign the logic for Y1 and Y3 within TopModule
    assign Y1 = w & y[0]; // State B can be reached from state A when w is 1
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // State D can be reached from states B, C, E, F when w is 0

endmodule