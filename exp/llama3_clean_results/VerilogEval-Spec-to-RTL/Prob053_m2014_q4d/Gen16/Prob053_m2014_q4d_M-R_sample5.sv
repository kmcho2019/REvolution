module TopModule(
    input clk,
    input in,
    output reg out
);

// Use a continuous assignment to express the combinational logic
// and an always block to handle the sequential logic of the D flip-flop
always @(posedge clk) begin
    out <= in ^ out; // Update out with the result of the XOR operation
end

endmodule