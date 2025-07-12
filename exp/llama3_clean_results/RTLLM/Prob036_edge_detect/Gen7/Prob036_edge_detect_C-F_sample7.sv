module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Initialize the previous state of 'a' to 0 for a known start condition
initial begin
    prev_a = 1'b0;
end

// Sequential logic to store the previous state of 'a' with explicit reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// Combinational logic for edge detection using explicit bitwise operations
assign rise = (a & ~prev_a);
assign down = (~a & prev_a);

endmodule