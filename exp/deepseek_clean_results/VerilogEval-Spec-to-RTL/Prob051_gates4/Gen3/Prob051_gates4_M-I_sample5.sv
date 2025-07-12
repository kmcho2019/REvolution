module TopModule (
    input      [3:0] in,   // 4-bit input vector
    output wire      out_and, // 4-input AND gate output
    output wire      out_or,  // 4-input OR gate output
    output wire      out_xor  // 4-input XOR gate output
);

    // Combinational logic using Verilog reduction operators
    assign out_and = &in; // AND reduction: out_and = in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in; // OR reduction:  out_or = in[3] | in[2] | in[1] | in[0]
    assign out_xor = ^in; // XOR reduction: out_xor = in[3] ^ in[2] ^ in[1] ^ in[0]

endmodule