module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;

// Two-input XOR gate
assign out = d_ff ^ in;

always_ff @(posedge clk)
    d_ff <= out;

endmodule