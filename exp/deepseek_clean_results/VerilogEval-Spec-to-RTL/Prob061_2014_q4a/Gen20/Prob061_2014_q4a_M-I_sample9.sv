module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_en = L | E;
wire D = L ? R : w;

always @(posedge clk)
    if (clk_en) Q <= D;

endmodule