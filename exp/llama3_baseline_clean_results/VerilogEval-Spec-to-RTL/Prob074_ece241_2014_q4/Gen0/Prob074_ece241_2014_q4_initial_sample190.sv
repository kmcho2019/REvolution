module TopModule(
    input  clk,
    input  x,
    output z
);

reg xor_ff, and_ff, or_ff;

// Combinational logic for the gates
wire xor_gate_out = x ^ xor_ff;
wire and_gate_out = x & ~and_ff;
wire or_gate_out = x | ~or_ff;

// Sequential logic for the D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_gate_out;
    and_ff <= and_gate_out;
    or_ff <= or_gate_out;
end

// NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

// Initial values for the D flip-flops
initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

endmodule