module TopModule (
    output zero
);
    reg q = 1'b0;  // Initialize flip-flop to 0
    wire clk;      // Clock input (unused in this case)
    
    // D flip-flop implementation
    always @(posedge clk) begin
        q <= 1'b0;  // Always load 0 into the flip-flop
    end
    
    assign zero = q;  // Output the flip-flop state
    
    // Note: In a real implementation, clk would need to be connected
    // This is just for demonstration purposes
endmodule