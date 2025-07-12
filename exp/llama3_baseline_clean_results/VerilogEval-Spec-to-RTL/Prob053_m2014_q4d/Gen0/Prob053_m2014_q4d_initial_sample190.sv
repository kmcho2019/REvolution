module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // Internal register to hold the output value

// XOR gate
wire xor_out;
assign xor_out = in ^ out_reg;

// D flip-flop
always @(posedge clk) begin
    out_reg <= xor_out;
end

// Output assignment
assign out = out_reg;

endmodule