module edge_detect (
    input  clk,       // Clock signal
    input  rst_n,      // Reset signal (active low)
    input  a,          // Input signal
    output rise,       // Output signal indicating a rising edge
    output down        // Output signal indicating a falling edge
);

reg prev_a;           // Register to store the previous state of 'a'

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;  // Reset 'prev_a' to 0 on reset
        rise   <= 1'b0;  // Reset 'rise' to 0 on reset
        down  <= 1'b0;  // Reset 'down' to 0 on reset
    end else begin
        // Detect rising edge
        if (a &&!prev_a) begin
            rise <= 1'b1;  // Set 'rise' to 1 on rising edge
            down <= 1'b0;  // Reset 'down' to 0
        end 
        // Detect falling edge
        else if (!a && prev_a) begin
            rise <= 1'b0;  // Reset 'rise' to 0
            down <= 1'b1;  // Set 'down' to 1 on falling edge
        end 
        // No edge detected
        else begin
            rise <= 1'b0;  // Reset 'rise' to 0
            down <= 1'b0;  // Reset 'down' to 0
        end
        
        prev_a <= a;       // Update 'prev_a' with the current state of 'a'
    end
end

endmodule