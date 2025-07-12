module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

reg xor_result;

assign xor_result = in ^ out;

always @(posedge clk)
    out <= xor_result;

endmodule