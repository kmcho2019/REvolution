module TopModule(
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;
wire xor_gate_in, and_gate_in, or_gate_in, xor_gate_out, and_gate_out, or_gate_out;

assign xor_gate_in = x;
assign and_gate_in = x;
assign or_gate_in = x;

assign xor_gate_out = xor_gate_in ^ xor_ff_out;
assign and_gate_out = and_gate_in & (~and_ff_out);
assign or_gate_out = or_gate_in | (~or_ff_out);

always @(posedge clk) begin
    xor_ff_out <= xor_gate_out;
    and_ff_out <= and_gate_out;
    or_ff_out <= or_gate_out;
end

assign z = ~(xor_gate_out | and_gate_out | or_gate_out);

endmodule