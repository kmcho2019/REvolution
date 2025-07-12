module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly implement the logic for Y1 and Y3 based on state transitions
    always @(*) begin
        Y1 = w & y[0];  // State B (y[1]) is reached from state A (y[0]) when w is 1
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);  // State D (y[3]) is reached from states B, C, E, and F when w is 0
    end

endmodule