module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

// Combinational logic for edge detection using explicit bitwise operations
assign rise = (a & ~prev_a);  // Detect rising edge
assign down = (~a & prev_a);  // Detect falling edge

endmodule