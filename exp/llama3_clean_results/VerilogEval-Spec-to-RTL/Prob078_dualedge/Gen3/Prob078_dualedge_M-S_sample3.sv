module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk; // Previous clock state

// Initialize previous clock state
initial prev_clk = 1'b0;

// Dual-edge triggered flip-flop
always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin // Clock edge detected
        q <= d; // Update output on both rising and falling edges
    end
    prev_clk <= clk; // Update previous clock state
end

endmodule