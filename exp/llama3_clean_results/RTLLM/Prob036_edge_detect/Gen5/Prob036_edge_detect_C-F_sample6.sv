module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'

// Initialize the output registers to 0
initial begin
    prev_a = 1'b0;
    rise = 1'b0;
    down = 1'b0;
end

// Store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

// Detect edges using combinational logic
assign rise = (a == 1'b1) && (prev_a == 1'b0);
assign down = (a == 1'b0) && (prev_a == 1'b1);

endmodule