module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // internal register to hold the output of the flip-flop

// describe the XOR operation
wire xor_out = in ^ out_reg;

// describe the D flip-flop
always @(posedge clk) begin
    out_reg <= xor_out;
end

// assign the output of the flip-flop to the output port
assign out = out_reg;

endmodule