module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state logic using continuous assignments
    wire next_A = (state_A & ~x) | (state_B & ~x);
    wire next_B = (state_A & x) | (state_B & x);

    // Mealy output depends on both current state and input
    assign z = x & (state_A | state_B);  // Equivalent to x ^ state_bit in original

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

endmodule