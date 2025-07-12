module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (1=B, 0=A)
    reg state_B;

    // Next state logic:
    // Toggle to B when x=1 in state A (state_B=0)
    // Stay in B once entered (state_B=1)
    wire next_state_B = state_B | (x & ~state_B);

    // Output logic: z = x XOR state_B
    assign z = x ^ state_B;

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end else begin
            state_B <= next_state_B;
        end
    end

endmodule