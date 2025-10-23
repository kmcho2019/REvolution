module TopModule(
    input clk,
    input in,
    output reg out
);

wire xor_out;
assign xor_out = in ^ out;

always @(posedge clk)
    out <= xor_out;

endmodule