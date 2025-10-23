module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out;

always @(*) begin
    next_out = in ^ out;
end

always @(posedge clk) begin
    out <= next_out;
end

endmodule