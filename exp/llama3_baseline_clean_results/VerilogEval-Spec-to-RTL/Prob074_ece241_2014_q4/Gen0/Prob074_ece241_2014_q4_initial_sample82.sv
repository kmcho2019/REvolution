module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff; // D flip-flop outputs

// XOR gate
wire xor_out = x ^ xor_ff;

// AND gate
wire and_out = x & ~and_ff;

// OR gate
wire or_out = x | ~or_ff;

// NOR gate
assign z = ~(xor_out | and_out | or_out);

// Update D flip-flop outputs on the positive edge of the clock
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Initialize D flip-flops to zero
initial begin
    xor_ff <= 0;
    and_ff <= 0;
    or_ff <= 0;
end

endmodule