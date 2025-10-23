module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_reg; // Internal register to hold the state of the flip-flop
assign out = out_reg; // Continuous assignment to output the current state

// Always block for sequential logic
always @(posedge clk) begin
    out_reg <= in ^ out; // Update the internal register at the positive edge of the clock
end

endmodule