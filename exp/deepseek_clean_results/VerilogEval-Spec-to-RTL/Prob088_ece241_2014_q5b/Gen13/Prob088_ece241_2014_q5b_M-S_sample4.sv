module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers
    reg state_A, state_B;

    // Output is x when in A, ~x when in B (equivalent to x XOR state_B)
    assign z = x ^ state_B;

    // State register updates with direct transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // Direct state transitions
            state_A <= state_A & ~x;
            state_B <= state_B | (state_A & x);
        end
    end

endmodule