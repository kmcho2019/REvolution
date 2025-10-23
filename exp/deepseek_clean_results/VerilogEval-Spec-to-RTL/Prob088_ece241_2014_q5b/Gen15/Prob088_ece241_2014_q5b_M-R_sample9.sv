module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State registers (one-hot)
    wire state_A, state_B;
    
    // Flip-flop with async reset for state A
    assign state_A = areset ? 1'b1 : 
                    (state_A & ~x) ? 1'b1 : 
                    1'b0;
    
    // Flip-flop with async reset for state B
    assign state_B = areset ? 1'b0 : 
                    (state_B | (state_A & x)) ? 1'b1 : 
                    1'b0;

    // Output logic remains the same (Mealy)
    assign z = state_A ? x : ~x;

endmodule