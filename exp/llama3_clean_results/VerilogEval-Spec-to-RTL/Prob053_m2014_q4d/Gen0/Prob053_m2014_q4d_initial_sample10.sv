module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_out;

always @ (posedge clk) begin
    out <= xor_out;
end

assign xor_out = in ^ out;

endmodule