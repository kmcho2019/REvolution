module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // State B (Y1) can be reached from state A when w is 1
    always @(*) begin
        Y1 = w & y[0];
    end

    // State D (Y3) can be reached from states B, C, E, and F when w is 0
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule