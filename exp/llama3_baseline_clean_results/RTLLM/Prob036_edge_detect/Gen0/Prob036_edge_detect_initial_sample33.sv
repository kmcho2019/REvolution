module edge_detect(
    input  clk,        // Clock signal
    input  rst_n,      // Reset signal (active low)
    input  a,          // Input signal
    output rise,       // Output signal indicating a rising edge
    output down        // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of signal 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        prev_a <= 1'b0; // Reset previous state of 'a'
        rise <= 1'b0;   // Reset 'rise' signal
        down <= 1'b0;  // Reset 'down' signal
    end else begin
        prev_a <= a;    // Update previous state of 'a'
        
        // Check for rising edge
        if (~prev_a && a) begin
            rise <= 1'b1; // Set 'rise' to 1
            down <= 1'b0; // Reset 'down' to 0
        end else if (prev_a && ~a) begin // Check for falling edge
            rise <= 1'b0; // Reset 'rise' to 0
            down <= 1'b1; // Set 'down' to 1
        end else begin
            rise <= 1'b0; // Reset 'rise' to 0 if no rising edge
            down <= 1'b0; // Reset 'down' to 0 if no falling edge
        end
    end
end

endmodule