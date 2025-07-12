module edge_detect(
    input clk,    // Clock signal
    input rst_n,  // Reset signal (active low)
    input a,     // Input signal
    output rise, // Output signal indicating a rising edge
    output down  // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous value of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        prev_a <= 1'b0;  // Initialize prev_a to 0
        rise <= 1'b0;   // Initialize rise to 0
        down <= 1'b0;   // Initialize down to 0
    end else begin
        prev_a <= a;  // Store the current value of 'a' in prev_a
        if (a && !prev_a) begin  // Rising edge detection
            rise <= 1'b1;  // Set rise to 1
            down <= 1'b0;  // Set down to 0
        end else if (!a && prev_a) begin  // Falling edge detection
            rise <= 1'b0;  // Set rise to 0
            down <= 1'b1;  // Set down to 1
        end else begin
            rise <= 1'b0;  // No edge, set rise to 0
            down <= 1'b0;  // No edge, set down to 0
        end
    end
end

endmodule