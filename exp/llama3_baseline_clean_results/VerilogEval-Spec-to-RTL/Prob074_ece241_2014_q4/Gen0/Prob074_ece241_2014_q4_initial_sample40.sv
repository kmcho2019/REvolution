module TopModule(
    input clk,
    input x,
    output z
);

// Internal signals for D flip-flop outputs
reg xor_ff_out, and_ff_out, or_ff_out;

// Internal signals for gate outputs
wire xor_gate_out, and_gate_out, or_gate_out;

// XOR gate with x and the output of its D flip-flop
assign xor_gate_out = x ^ xor_ff_out;

// AND gate with x and the complement of the output of its D flip-flop
assign and_gate_out = x & ~and_ff_out;

// OR gate with x and the complement of the output of its D flip-flop
assign or_gate_out = x | ~or_ff_out;

// D flip-flops capturing gate outputs on the positive edge of clk
always @(posedge clk) begin
    xor_ff_out <= xor_gate_out;
    and_ff_out <= and_gate_out;
    or_ff_out <= or_gate_out;
end

// Initial reset of D flip-flops to zero
initial begin
    xor_ff_out = 0;
    and_ff_out = 0;
    or_ff_out = 0;
end

// Three-input NOR gate for final output Z
assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

endmodule