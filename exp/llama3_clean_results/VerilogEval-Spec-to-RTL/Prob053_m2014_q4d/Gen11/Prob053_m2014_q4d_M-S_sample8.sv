module TopModule(
    input clk,
    input in,
    output reg out
);

// Sequential logic: D flip-flop with XOR operation
always @(posedge clk) begin
    out <= in ^ out;
end

endmodule