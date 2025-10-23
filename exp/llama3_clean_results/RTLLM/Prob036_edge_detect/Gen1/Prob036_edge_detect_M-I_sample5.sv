module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'

// Initialize the previous state of 'a' to 0
initial begin
    prev_a = 1'b0;
end

// Main logic for edge detection
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
    end else begin
        // Store the current state of 'a' for the next clock cycle
        prev_a <= a;
    end
end

// Assign the edge detection signals directly
assign rise = (prev_a == 1'b0) && (a == 1'b1);
assign down = (prev_a == 1'b1) && (a == 1'b0);

endmodule