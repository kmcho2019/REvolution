module TopModule(
    input clk,
    input in,
    output reg out
);

always @ (posedge clk) begin
    out <= in ^ out; // Directly update out based on the XOR of in and current out
end

endmodule