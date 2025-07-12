module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Single-bit state register (0=A, 1=B)
    reg state;
    
    // State transition as Boolean equations
    wire state_d = areset ? 1'b1 : 
                  (state & in) | (~state & ~in);
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B
        else
            state <= state_d;
    end
    
    // Output is simply the state bit (B=1)
    assign out = state;
    
endmodule