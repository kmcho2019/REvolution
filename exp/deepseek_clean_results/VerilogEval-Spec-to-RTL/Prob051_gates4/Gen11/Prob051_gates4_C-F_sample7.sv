module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // AND reduction: out = in[3] & in[2] & in[1] & in[0]
    output out_or,        // OR reduction:  out = in[3] | in[2] | in[1] | in[0]
    output out_xor        // XOR reduction: out = in[3] ^ in[2] ^ in[1] ^ in[0]
);

    // Optimal implementation using Verilog reduction operators
    assign out_and = &in; // 4-input AND
    assign out_or  = |in; // 4-input OR
    assign out_xor = ^in; // 4-input XOR (synthesizer will choose optimal implementation)

endmodule