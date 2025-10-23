module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Combine sequential logic for storing previous state and edge detection
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset to known state
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store previous state of 'a'
        prev_a <= a;
        
        // Detect edges and set outputs accordingly
        if (a &&!prev_a) begin
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule