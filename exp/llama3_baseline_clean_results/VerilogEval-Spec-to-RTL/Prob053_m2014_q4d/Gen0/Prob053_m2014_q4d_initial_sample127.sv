module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // register to hold the output of the flip-flop
assign out = out_reg; // continuous assignment to output

// XOR gate
wire xor_out;
assign xor_out = in ^ out;

// D flip-flop
always @(posedge clk) begin
    out_reg <= xor_out;
end

endmodule