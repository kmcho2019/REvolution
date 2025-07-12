module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B
    
    // Simplified next state logic
    wire next_state = areset ? 1'b1 : 
                     (state ? (in ? 1'b1 : 1'b0) : 
                     (in ? 1'b0 : 1'b1);
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B
        else
            state <= next_state;
    end
    
    // Output is simply the state (B=1, A=0)
    assign out = state;
    
endmodule