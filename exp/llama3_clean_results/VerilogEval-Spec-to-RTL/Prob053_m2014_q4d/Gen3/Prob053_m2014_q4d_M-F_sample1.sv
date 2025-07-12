module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_result;

always @(posedge clk) begin
    xor_result <= in ^ out;
    out <= xor_result;
end

endmodule