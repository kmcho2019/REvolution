module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_B), state_A is ~state_B
    reg state_B;

    // Next state logic - simplified sticky behavior
    // Once in state_B, stay there; only enter when x=1 in state_A
    wire next_state_B = state_B | (x & ~state_B);

    // Output logic - optimized to single XOR gate
    assign z = state_B ^ x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule