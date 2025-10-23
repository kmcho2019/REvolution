module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State registers implemented as DFFs with continuous assignment
    reg state_A, state_B;

    // State transition logic (combinational)
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | state_B;

    // Output logic (combinational Mealy output)
    assign z = state_A ? x : ~x;

    // State register updates using continuous assignment
    assign state_A = areset ? 1'b1 : (clk ? next_state_A : state_A);
    assign state_B = areset ? 1'b0 : (clk ? next_state_B : state_B);

endmodule