module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly assign the next-state values for Y1 and Y3
    assign Y1 = w & y[0]; // Next state for y[1]
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // Next state for y[3]

endmodule