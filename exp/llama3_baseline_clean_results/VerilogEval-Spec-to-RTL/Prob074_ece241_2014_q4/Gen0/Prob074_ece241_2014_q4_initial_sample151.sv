module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;

// Initialize flip-flops to zero
initial begin
    xor_out = 0;
    and_out = 0;
    or_out = 0;
end

// D flip-flops triggered on positive edge of clk
always @(posedge clk) begin
    // XOR gate with input x and flip-flop output
    reg xor_gate_out;
    assign xor_gate_out = x ^ xor_out;
    xor_out <= xor_gate_out;

    // AND gate with input x and flip-flop's complemented output
    reg and_gate_out;
    assign and_gate_out = x & ~and_out;
    and_out <= and_gate_out;

    // OR gate with input x and flip-flop's complemented output
    reg or_gate_out;
    assign or_gate_out = x | ~or_out;
    or_out <= or_gate_out;
end

// NOR gate with outputs of the three gates
assign z = ~(xor_out | and_out | or_out);

endmodule