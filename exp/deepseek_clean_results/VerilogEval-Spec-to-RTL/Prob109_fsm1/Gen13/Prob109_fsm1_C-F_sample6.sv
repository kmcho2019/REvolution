module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (B=1, A=0)
    reg state;
    
    // Next state logic using optimized boolean equation
    wire next_state = areset ? 1'b1 : (state ^ ~in);
    
    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to B
        else
            state <= next_state;
    end
    
    // Output is simply the state (B=1, A=0)
    assign out = state;
    
endmodule