module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Clocked state transitions with asynchronous reset
    assign state_A = areset ? 1'b1 : 
                   ~clk ? state_A :
                   state_A & ~x;
    
    assign state_B = areset ? 1'b0 : 
                   ~clk ? state_B :
                   state_B | (state_A & x);

    // Output logic remains combinational
    assign z = state_A ? x : ~x;

endmodule