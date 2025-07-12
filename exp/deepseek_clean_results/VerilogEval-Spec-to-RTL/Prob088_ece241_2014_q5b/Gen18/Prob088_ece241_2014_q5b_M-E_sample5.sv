module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State representation: 0=A, 1=B
    reg state;

    // Next state logic: transition to B when in A and x=1, otherwise stay
    wire next_state = state | (x & ~state);

    // Output logic: z = x XOR state (implements the required truth table)
    assign z = x ^ state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to state A
        else
            state <= next_state;
    end

endmodule