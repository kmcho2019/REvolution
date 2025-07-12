module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'

// Initialize the output registers to 0
initial begin
    prev_a = 1'b0;
end

// Store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

// Detect edges using combinational logic
assign rise = (prev_a == 1'b0) && (a == 1'b1);
assign down = (prev_a == 1'b1) && (a == 1'b0);

endmodule