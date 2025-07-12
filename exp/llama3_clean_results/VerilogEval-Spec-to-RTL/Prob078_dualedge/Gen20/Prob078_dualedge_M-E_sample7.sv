module TopModule(
    input clk,  // Clock signal
    input d,    // Input data
    output reg q  // Output data
);

// Internal signal to store the previous clock state
reg prev_clk;

// Clock edge detector
reg rising_edge, falling_edge;
always @(posedge clk or negedge clk) begin
    // Update previous clock state
    prev_clk <= clk;
    // Detect rising edge
    rising_edge <= (clk == 1'b1) && (prev_clk == 1'b0);
    // Detect falling edge
    falling_edge <= (clk == 1'b0) && (prev_clk == 1'b1);
end

// Dual-edge triggered flip-flop
always @(posedge rising_edge or posedge falling_edge) begin
    // Update output on detected edges
    q <= d;
end

// Initialize previous clock state and edge detectors
initial begin
    prev_clk = 1'b0;
    rising_edge = 1'b0;
    falling_edge = 1'b0;
end

endmodule