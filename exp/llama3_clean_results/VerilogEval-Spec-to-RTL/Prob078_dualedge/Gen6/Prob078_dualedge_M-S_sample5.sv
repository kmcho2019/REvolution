module TopModule(
    input clk,
    input d,
    output reg q
);

reg enable;

// Toggle enable on every clock edge
always @(posedge clk or negedge clk)
    enable <= ~enable;

// Single flip-flop with toggling enable
always @(posedge enable)
    q <= d;

endmodule