module TopModule (
    input clk,
    input in,
    output logic out
);

logic flipflop_output;
logic xor_output;

// Instantiate XOR gate
XOR_gate xor_gate(.a(in), .b(flipflop_output), .y(xor_output));

// D flip-flop without reset
always_ff @(posedge clk)
    flipflop_output <= xor_output;

assign out = flipflop_output;

endmodule

module XOR_gate (
    input a,
    input b,
    output logic y
);
assign y = a ^ b;
endmodule