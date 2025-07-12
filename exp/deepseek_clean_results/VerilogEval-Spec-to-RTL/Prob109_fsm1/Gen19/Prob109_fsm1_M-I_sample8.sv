module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (B=1, A=0)
    reg state;
    
    // Next state logic simplified
    wire next_state = (state & in) | (~state & ~in);
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B (1)
        else
            state <= next_state;
    end
    
    // Output is directly the state bit
    assign out = state;
    
endmodule