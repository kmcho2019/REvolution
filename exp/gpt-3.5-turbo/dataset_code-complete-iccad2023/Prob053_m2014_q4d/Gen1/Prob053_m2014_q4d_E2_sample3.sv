module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;
logic xor_out;

// Two-input XOR gate
assign xor_out = in ^ out;

always_ff @(posedge clk)
    d_ff <= xor_out;

assign out = d_ff;

endmodule