module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;  // Initialize D flip-flop outputs

// XOR gate
wire xor_gate = x ^ xor_ff;

// AND gate
wire and_gate = x & ~and_ff;

// OR gate
wire or_gate = x | ~or_ff;

// D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_gate;
    and_ff <= and_gate;
    or_ff <= or_gate;
end

// Three-input NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

endmodule