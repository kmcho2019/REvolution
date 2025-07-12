module pe (
    input clk,
    input rst,
    input signed [31:0] a,
    input signed [31:0] b,
    output reg signed [31:0] c
);

always @(posedge clk)
    c <= rst ? 32'sb0 : c + a * b;

endmodule