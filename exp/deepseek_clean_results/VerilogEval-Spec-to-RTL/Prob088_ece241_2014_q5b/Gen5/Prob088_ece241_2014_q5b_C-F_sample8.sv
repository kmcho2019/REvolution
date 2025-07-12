module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_B) with state_A implied as ~state_B
    // This maintains one-hot encoding while minimizing area
    reg state_B;

    // Optimized next state logic - state_B becomes and stays 1 when x=1 in state A
    wire next_state_B = state_B | (x & ~state_B);

    // Output logic - z is x XOR state_B (x in A, ~x in B)
    assign z = state_B ^ x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0, state_A=1)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule