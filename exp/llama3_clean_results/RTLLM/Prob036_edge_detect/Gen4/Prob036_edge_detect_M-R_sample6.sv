module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'

// Main logic for edge detection
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' for the next clock cycle
        prev_a <= a;
        
        // Update rise and down signals based on edge detection
        if (prev_a == 1'b0 && a == 1'b1) begin
            rise <= 1'b1;
            down <= 1'b0;
        end else if (prev_a == 1'b1 && a == 1'b0) begin
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule