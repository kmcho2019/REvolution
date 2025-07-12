module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers with continuous assignment
    wire state_A, state_B;
    
    // State register updates with asynchronous reset
    assign state_A = areset ? 1'b1 : 
                    (state_A & ~x) | (state_B & ~x);
    assign state_B = areset ? 1'b0 : 
                    (state_A & x) | (state_B);

    // Output logic (combinational Mealy output)
    assign z = state_A ? x : ~x;

endmodule