module TopModule(
    input clk,
    input in,
    output reg out
);

reg internal_out;

always @(posedge clk) begin
    internal_out <= in ^ out;
end

assign out = internal_out;

endmodule