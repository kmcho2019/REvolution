module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;

// Initialize prev_clk to 0 (assuming initial clock state is low)
initial prev_clk = 0;

// Detect clock edges
always @(posedge clk or negedge clk) begin
    if (prev_clk!= clk) begin
        // If clock edge detected, latch input signal 'd'
        q <= d;
    end
    prev_clk <= clk;
end

endmodule