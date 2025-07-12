module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;

assign xor_gate_out = x ^ xor_ff;
assign and_gate_out = x & ~and_ff;
assign or_gate_out = x | ~or_ff;

always @(posedge clk) begin
    xor_ff <= xor_gate_out;
    and_ff <= and_gate_out;
    or_ff <= or_gate_out;
end

assign z = ~(xor_ff | and_ff | or_ff);

initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

endmodule