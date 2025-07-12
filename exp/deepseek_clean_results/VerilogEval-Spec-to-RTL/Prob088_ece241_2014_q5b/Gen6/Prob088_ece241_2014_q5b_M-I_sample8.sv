module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single-bit state representation (0=A, 1=B)
    reg state_bit;

    // Optimized next state logic
    wire next_state = state_bit | x;

    // Optimized output logic - z = x XOR state_bit
    assign z = x ^ state_bit;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_bit <= 1'b0;  // Reset to state A
        end
        else begin
            state_bit <= next_state;
        end
    end

endmodule