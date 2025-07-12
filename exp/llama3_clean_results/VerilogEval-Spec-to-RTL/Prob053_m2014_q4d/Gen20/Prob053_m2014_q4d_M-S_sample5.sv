module TopModule(
    input clk,
    input in,
    output reg out
);

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= in ^ out;  // This line directly computes the next state based on the current 'out' and 'in'
end

endmodule