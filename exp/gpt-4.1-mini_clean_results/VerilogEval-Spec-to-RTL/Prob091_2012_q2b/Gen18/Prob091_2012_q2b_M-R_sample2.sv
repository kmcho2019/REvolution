module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default outputs to zero
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Y1 corresponds to next input of state B (y[1])
        // From FSM: Y1 = y[0] & w
        if (y[0] && w)
            Y1 = 1'b1;

        // Y3 corresponds to next input of state D (y[3])
        // From FSM: Y3 = ~w & ~(y[0] | y[3])
        if ((~w) && ~(y[0] | y[3]))
            Y3 = 1'b1;
    end

endmodule