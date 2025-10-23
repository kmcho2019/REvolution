module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // register to hold the output of the flip-flop

// XOR gate
wire xor_out;
assign xor_out = in ^ out_reg;

// D flip-flop
always @(posedge clk) begin
    out_reg <= xor_out;
end

// continuous assignment for output
assign out = out_reg;

endmodule