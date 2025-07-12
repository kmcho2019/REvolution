module TopModule(
    input clk,
    input in,
    output reg out
);

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= in ^ out;  // Update 'out' with the XOR of 'in' and 'out'
end

endmodule