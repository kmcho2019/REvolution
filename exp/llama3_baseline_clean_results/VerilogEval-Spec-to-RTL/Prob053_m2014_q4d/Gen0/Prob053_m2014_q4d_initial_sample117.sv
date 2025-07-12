module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output
assign out = out_reg; // Continuous assignment for output

// D flip-flop with positive edge trigger
always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR of 'in' and the current 'out'
end

endmodule