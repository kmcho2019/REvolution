module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register representing state A
    reg state_A;

    // Next state logic - state_A remains only when x=0
    wire next_state_A = state_A & ~x;

    // Output logic - Mealy output depends on both state and input
    assign z = state_A ? x : ~x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

endmodule