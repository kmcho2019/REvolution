module TopModule(
    input clk,
    input in,
    output reg out
);

reg temp_out;

always @ (posedge clk)
    temp_out <= in ^ out;

assign out = temp_out;

endmodule