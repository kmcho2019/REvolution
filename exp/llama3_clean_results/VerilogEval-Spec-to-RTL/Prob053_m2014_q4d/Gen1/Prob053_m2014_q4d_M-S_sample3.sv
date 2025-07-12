module TopModule(
    input clk,
    input in,
    output reg out
);

reg temp;

always @(posedge clk) begin
    temp = in ^ out;
    out <= temp;
end

endmodule