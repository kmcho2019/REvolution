module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // All outputs implemented using Verilog reduction operators
    assign out_and = &in;  // AND reduction: out = in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in;  // OR reduction:  out = in[3] | in[2] | in[1] | in[0]
    assign out_xor = ^in;  // XOR reduction: out = in[3] ^ in[2] ^ in[1] ^ in[0]

endmodule