module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;
always_ff @(posedge clk)
    d_ff <= xor2(in, d_ff);

// Two-input XOR gate
assign out = in ^ d_ff;

endmodule