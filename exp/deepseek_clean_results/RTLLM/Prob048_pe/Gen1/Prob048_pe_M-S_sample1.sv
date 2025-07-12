module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @(posedge clk) begin
    c <= rst ? 32'd0 : c + a * b;
end

endmodule