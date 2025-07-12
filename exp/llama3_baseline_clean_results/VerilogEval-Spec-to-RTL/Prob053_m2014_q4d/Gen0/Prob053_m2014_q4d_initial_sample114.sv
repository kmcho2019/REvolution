module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // internal register to store the state of the flip-flop

// Assign out to out_reg
assign out = out_reg;

// Update out_reg on the positive edge of clk
always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR operation
end

endmodule