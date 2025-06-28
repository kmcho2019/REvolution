module TopModule (
    input clk,
    input in,
    output logic out
);

// D flip-flop without reset
logic d_ff;
always_ff @(posedge clk)
    d_ff <= xor(in, d_ff);

// Two-input XOR gate
function logic xor;
    input a, b;
    xor = a ^ b;
endfunction

assign out = d_ff;

endmodule