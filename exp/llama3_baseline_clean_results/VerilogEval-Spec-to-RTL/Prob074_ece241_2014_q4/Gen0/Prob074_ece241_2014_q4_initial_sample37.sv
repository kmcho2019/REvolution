module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out; // outputs of the D flip-flops

// calculate the outputs of the gates
wire xor_gate_out = x ^ xor_out;
wire and_gate_out = x & ~and_out;
wire or_gate_out = x | ~or_out;

// update the D flip-flop outputs on the positive edge of the clock
always @(posedge clk) begin
    xor_out <= xor_gate_out;
    and_out <= and_gate_out;
    or_out <= or_gate_out;
end

// calculate the output of the NOR gate
assign z = ~(xor_out | and_out | or_out);

// reset the D flip-flops to zero
initial begin
    xor_out = 0;
    and_out = 0;
    or_out = 0;
end

endmodule