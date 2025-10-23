module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

// Combinational multiply-accumulate path
wire signed [31:0] mac_result = c + (a * b);

always @(posedge clk) begin
    c <= rst ? 32'd0 : mac_result;
end

endmodule