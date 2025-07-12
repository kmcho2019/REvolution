module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    out <= in ^ out; // Directly describe the XOR operation and the flip-flop's behavior
end

endmodule