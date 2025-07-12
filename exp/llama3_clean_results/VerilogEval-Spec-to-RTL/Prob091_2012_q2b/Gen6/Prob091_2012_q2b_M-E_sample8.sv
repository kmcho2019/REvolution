module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        // Determine next state value for Y1 (state B)
        Y1 = w & y[0];  // State B can be reached from state A when w is 1

        // Determine next state value for Y3 (state D)
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);  // State D can be reached from states B, C, E, and F when w is 0
    end

endmodule