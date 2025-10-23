module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // True one-hot state registers
    reg state_A, state_B;

    // Next state logic - optimized version
    wire next_state_A = ~x & state_A;
    wire next_state_B = (x & state_A) | state_B;

    // Output logic - efficient XOR
    assign z = state_B ^ x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule