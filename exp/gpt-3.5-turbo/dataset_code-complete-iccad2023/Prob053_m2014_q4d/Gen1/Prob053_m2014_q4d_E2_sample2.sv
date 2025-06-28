module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;
always_ff @(posedge clk)
    d_ff <= xor2(in, out);

// Two-input XOR gate
assign out_xor = in ^ out;

assign out = d_ff;

endmodule