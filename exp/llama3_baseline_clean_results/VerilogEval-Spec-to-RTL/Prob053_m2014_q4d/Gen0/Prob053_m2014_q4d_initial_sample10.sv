module TopModule(
    input clk,
    input in,
    output reg out
);

reg d_ff_out;

always @(posedge clk) begin
    d_ff_out <= in ^ out;
end

assign out = d_ff_out;

endmodule