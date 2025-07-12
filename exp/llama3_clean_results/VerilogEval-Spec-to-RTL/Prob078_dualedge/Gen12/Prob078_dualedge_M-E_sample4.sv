module TopModule(
    input clk,
    input d,
    output reg q
);

reg pulse;

// Pulse generator for positive and negative edges
always @(*)
    pulse = (clk!= $past(clk));

// Single flip-flop triggered by the pulse
always @(posedge pulse)
    q <= d;

endmodule