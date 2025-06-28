module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;
always_ff @(posedge clk)
    d_ff <= d_ff ^ in;

// Two-input XOR gate
assign out = d_ff;

endmodule