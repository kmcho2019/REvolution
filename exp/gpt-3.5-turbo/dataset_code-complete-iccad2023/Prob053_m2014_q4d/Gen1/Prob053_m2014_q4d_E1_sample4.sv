module TopModule (
    input clk,
    input in,
    output logic out
);

// XOR gate
logic xor_output;
always_comb
    xor_output = in ^ out;

// D flip-flop without reset
logic d_ff;
always_ff @(posedge clk)
    d_ff <= xor_output;

assign out = d_ff;

endmodule