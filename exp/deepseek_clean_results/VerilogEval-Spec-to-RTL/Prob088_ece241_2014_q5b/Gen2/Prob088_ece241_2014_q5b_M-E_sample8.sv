module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state_A = !state_B, state_B = state_B
    reg state_B;

    // Edge detector for first '1' - becomes the state transition condition
    wire first_one = x & ~state_B;

    // Output logic - XOR of input and state_B
    assign z = x ^ state_B;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
        end
        else if (first_one) begin
            state_B <= 1'b1;  // Transition to state B on first '1'
        end
        // Once in state B, remain there forever
    end

endmodule