module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // Register to hold the output of the D flip-flop

// D flip-flop behavior on positive edge of clk
always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR of 'in' and current 'out' (which is out_reg)
end

// Continuous assignment for output
assign out = out_reg;

endmodule