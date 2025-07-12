module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Output is Mealy-type: z = x XOR state_B
    assign z = x ^ state_B;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= state_A & ~x;  // Stay in A only if x=0
            state_B <= (state_A & x) | state_B;  // Enter B if (A and x=1) or already in B
        end
    end

endmodule