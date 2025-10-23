module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_d;

// Generate a delayed version of the clock signal
assign clk_d = #1 clk; // assuming a 1-unit delay buffer chain

// Single-edge triggered flip-flop
always @(posedge clk_d)
    q <= d;

endmodule