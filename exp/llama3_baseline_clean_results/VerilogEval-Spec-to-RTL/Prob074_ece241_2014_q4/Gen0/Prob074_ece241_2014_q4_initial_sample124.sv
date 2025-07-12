module TopModule(
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;
wire xor_gate_out, and_gate_out, or_gate_out;

// XOR gate
assign xor_gate_out = x ^ xor_ff_out;

// AND gate
assign and_gate_out = x & ~and_ff_out;

// OR gate
assign or_gate_out = x | ~or_ff_out;

// D flip-flops
always @(posedge clk) begin
    xor_ff_out <= xor_gate_out;
    and_ff_out <= and_gate_out;
    or_ff_out <= or_gate_out;
end

// NOR gate
assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

// Initialize flip-flops to zero
initial begin
    xor_ff_out = 0;
    and_ff_out = 0;
    or_ff_out = 0;
end

endmodule