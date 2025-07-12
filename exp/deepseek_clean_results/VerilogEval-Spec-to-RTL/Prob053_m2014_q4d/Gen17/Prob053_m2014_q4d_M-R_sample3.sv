module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire clk_prev;
    wire xor_out = in ^ state;
    
    // Clock edge detection and state update
    assign state = (clk & ~clk_prev) ? xor_out : state;
    
    // Previous clock state tracking
    assign clk_prev = clk;
    
    // Output assignment
    assign out = state;

endmodule