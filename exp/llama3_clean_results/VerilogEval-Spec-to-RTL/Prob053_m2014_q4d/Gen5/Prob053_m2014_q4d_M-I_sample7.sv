module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    out <= in ^ out; // Update the output of the flip-flop
end

endmodule