module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Assign the next-state values for Y1 and Y3 directly
    // without using an intermediate module for simplicity
    always @(*) begin
        Y1 = w & y[0]; // Transition from A to B
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // Transition to D from B, C, E, F
    end

endmodule