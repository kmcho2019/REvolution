module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_A)
    reg state_A;

    // Next state logic - only transition when x=1 in state A
    wire next_state_A = (state_A & ~x) | (~state_A & state_A); // Simplified to state_A & ~x

    // Optimized output logic: z = x ^ state_A
    assign z = x ^ state_A;

    // State register updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A
            state_A <= 1'b1;
        end else begin
            // Only update state when necessary
            state_A <= next_state_A;
        end
    end

endmodule