module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single-bit state representation (0=A, 1=B)
    reg state_bit;

    // Mealy output depends on both current state and input
    assign z = x ^ state_bit;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_bit = 1'b0;  // Reset to state A (blocking for async reset)
        end
        else begin
            state_bit <= state_bit | x;  // Direct next state computation
        end
    end

endmodule