module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B
    
    // Simplified next state logic using XOR and AND
    wire next_state = areset ? 1'b1 : 
                     (state ^ in) ? 1'b0 : 1'b1;
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B
        else
            state <= next_state;
    end
    
    // Output is simply the state bit (B=1)
    assign out = state;
    
endmodule