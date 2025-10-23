module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_out;

always @(*) begin
    xor_out = in ^ out;
end

always @ (posedge clk) begin
    out <= xor_out;
end

endmodule