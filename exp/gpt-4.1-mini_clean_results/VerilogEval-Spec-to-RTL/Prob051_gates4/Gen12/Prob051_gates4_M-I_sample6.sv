module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);

    // Combinational logic using reduction operators for AND and OR.
    // For XOR, use a balanced XOR tree to potentially improve PPA.
    // This may help synthesis tools map XOR logic more efficiently.

    assign out_and = &in;
    assign out_or  = |in;

    // Balanced XOR tree implementation for 4 inputs:
    wire xor_stage1_0, xor_stage1_1;

    assign xor_stage1_0 = in[0] ^ in[1];
    assign xor_stage1_1 = in[2] ^ in[3];
    assign out_xor     = xor_stage1_0 ^ xor_stage1_1;

endmodule