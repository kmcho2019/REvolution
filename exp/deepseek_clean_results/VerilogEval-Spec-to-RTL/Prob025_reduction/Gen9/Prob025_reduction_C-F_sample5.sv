module TopModule (
    input [7:0] in,
    output parity
);
    // Implementation note: The synthesis tool will implement this as:
    // stage1[0] = in[0] ^ in[1]
    // stage1[1] = in[2] ^ in[3]
    // stage1[2] = in[4] ^ in[5]
    // stage1[3] = in[6] ^ in[7]
    // stage2[0] = stage1[0] ^ stage1[1]
    // stage2[1] = stage1[2] ^ stage1[3]
    // parity = stage2[0] ^ stage2[1]
    assign parity = ^in;  // Even parity via reduction XOR
endmodule