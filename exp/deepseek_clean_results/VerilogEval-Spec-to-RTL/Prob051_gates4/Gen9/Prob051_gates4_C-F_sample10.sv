module TopModule(
    input  wire [3:0] in,   // 4-bit input bus
    output wire       out_and,  // 4-input AND reduction
    output wire       out_or,   // 4-input OR reduction
    output wire       out_xor   // 4-input XOR reduction
);

    // Implement all outputs using Verilog reduction operators
    // These synthesize to optimal gate-level implementations
    assign out_and = &in;  // out = in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in;  // out = in[3] | in[2] | in[1] | in[0]
    assign out_xor = ^in;  // out = in[3] ^ in[2] ^ in[1] ^ in[0]

endmodule