module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly implement the next-state logic for Y1 and Y3
    assign Y1 = w & y[0]; // Transition from A to B
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // Transition to D from B, C, E, F

endmodule