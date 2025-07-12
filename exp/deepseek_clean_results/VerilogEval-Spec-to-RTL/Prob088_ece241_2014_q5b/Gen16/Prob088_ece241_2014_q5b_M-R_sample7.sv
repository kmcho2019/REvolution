module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers (now driven by continuous assignments)
    wire state_A, state_B;

    // State register updates with asynchronous reset
    assign state_A = areset ? 1'b1 : (state_A & ~x);
    assign state_B = areset ? 1'b0 : (state_B | (state_A & x));

    // Output logic remains the same (combinational Mealy output)
    assign z = state_A ? x : ~x;

endmodule