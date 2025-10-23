module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Explicit initialization to avoid X values
);

always @(posedge clk) begin
    // Directly update out with the XOR result to minimize area and improve performance
    out <= in ^ out;
end

endmodule