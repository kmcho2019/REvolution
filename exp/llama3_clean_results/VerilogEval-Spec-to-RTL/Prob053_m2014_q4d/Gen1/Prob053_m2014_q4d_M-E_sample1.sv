module TopModule(
    input clk,
    input in,
    output reg out
);

reg temp_out;

always @(*) begin
    temp_out = in ^ out;
end

always @(posedge clk) begin
    out <= temp_out;
end

endmodule