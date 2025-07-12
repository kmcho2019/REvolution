module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // internal register for the D flip-flop output
wire xor_out; // output of the XOR gate

// Instantiate the XOR gate
assign xor_out = in ^ out_reg;

// D flip-flop
always @ (posedge clk) begin
    out_reg <= xor_out;
end

// Assign the output of the flip-flop to the output port
assign out = out_reg;

endmodule