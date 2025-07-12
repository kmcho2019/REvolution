module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (1'b0 = A, 1'b1 = B)
    reg state;
    
    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B
        else
            state <= in ^ ~state;  // Equivalent to: in ? state : ~state
    end
    
    // Output logic
    assign out = state;  // Direct state output (B=1, A=0)
    
endmodule