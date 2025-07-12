module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

always @(posedge clk)
    out <= in ^ out;

endmodule