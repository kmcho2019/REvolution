module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly assign Y1 and Y3 based on the state machine's transitions
    // Y1 corresponds to state B and can be reached from state A when w is 1
    always @(*) begin
        Y1 = w & y[0];
    end

    // Y3 corresponds to state D and can be reached from states B, C, E, and F under specific conditions
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule