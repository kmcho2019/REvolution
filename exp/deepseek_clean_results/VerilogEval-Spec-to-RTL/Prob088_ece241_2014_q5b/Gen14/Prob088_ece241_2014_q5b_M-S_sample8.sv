module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state register (only need to track state_A since state_B is its complement)
    reg state_A;

    // Next state logic - state_A remains only when x=0
    wire next_state_A = state_A & ~x;

    // Output is XOR of state_A and x
    assign z = state_A ^ x;

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

endmodule