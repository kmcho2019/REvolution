module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: 0 = COPY, 1 = INVERT
    logic state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // COPY state
        else
            state <= next_state;
    end

    // Next state logic combinational
    // In COPY state, transition to INVERT if x == 1, else stay in COPY
    // In INVERT state, remain in INVERT
    always_comb begin
        if (state == 1'b0) // COPY
            next_state = x ? 1'b1 : 1'b0;
        else // INVERT
            next_state = 1'b1;
    end

    // Output logic: z = x XOR inversion_bit (state)
    assign z = x ^ state;

endmodule