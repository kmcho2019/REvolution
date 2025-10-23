module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly implement the next state logic for Y1 (state B)
    // Y1 is set when the current state is A (y[0]) and w is 1
    always @(*) begin
        Y1 = w & y[0];
    end

    // Directly implement the next state logic for Y3 (state D)
    // Y3 is set when w is 0 and the current state is B, C, E, or F
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule