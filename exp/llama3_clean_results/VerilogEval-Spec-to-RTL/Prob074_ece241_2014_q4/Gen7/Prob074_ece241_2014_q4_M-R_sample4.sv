module TopModule(
    input  clk,
    input  x,
    output reg z
);

// Declare the flip-flop outputs
reg q_xor, q_and, q_or;

// Calculate the XOR gate output
wire xor_gate_out;
assign xor_gate_out = x ^ q_xor;

// Calculate the AND gate output
wire and_gate_out;
assign and_gate_out = x & ~q_and;

// Calculate the OR gate output
wire or_gate_out;
assign or_gate_out = x | ~q_or;

// Update the flip-flops
always @(posedge clk) begin
    q_xor <= xor_gate_out;
    q_and <= and_gate_out;
    q_or <= or_gate_out;
end

// Calculate the output z using the NOR gate
assign z = ~(xor_gate_out | and_gate_out | or_gate_out);

endmodule