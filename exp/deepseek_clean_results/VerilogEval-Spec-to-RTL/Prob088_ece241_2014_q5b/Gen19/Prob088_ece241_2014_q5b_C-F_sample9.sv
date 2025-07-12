module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register representing state A
    // state_B is implicitly ~state_A in this one-hot encoding
    reg state_A;

    // Next state logic - only transitions when x=0 in state A
    wire next_state_A = state_A & ~x;

    // Output logic - Mealy outputs based on current state and input
    assign z = state_A ? x : ~x;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

endmodule