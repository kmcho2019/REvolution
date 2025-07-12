module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff; // Flip-flop outputs

// Combinational logic for the gates
wire xor_gate_out, and_gate_out, or_gate_out;

assign xor_gate_out = x ^ xor_ff;
assign and_gate_out = x & ~and_ff;
assign or_gate_out = x | ~or_ff;

// Sequential logic for the D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_gate_out;
    and_ff <= and_gate_out;
    or_ff <= or_gate_out;
end

// NOR gate for final output
assign z = ~(xor_ff | and_ff | or_ff);

endmodule