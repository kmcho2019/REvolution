module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    out <= in ^ out; // The XOR operation with the current out value (feedback)
end

endmodule