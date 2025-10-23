module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    out <= in ^ out; // Directly use 'out' in the XOR operation
end

endmodule