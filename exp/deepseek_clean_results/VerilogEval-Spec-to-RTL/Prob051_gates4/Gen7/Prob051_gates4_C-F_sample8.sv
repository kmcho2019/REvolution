module TopModule (
    input [3:0] in,       // 4-bit input
    output out_and,       // AND of all 4 bits (1 only if all inputs are 1)
    output out_or,        // OR of all 4 bits (1 if any input is 1)
    output out_xor        // XOR of all 4 bits (1 if odd number of inputs are 1)
);

    // Primary implementation using efficient reduction operators
    assign out_and = &in; // AND reduction: out_and = in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in; // OR reduction:  out_or = in[3] | in[2] | in[1] | in[0]
    assign out_xor = ^in; // XOR reduction: out_xor = in[3] ^ in[2] ^ in[1] ^ in[0]

    /* Alternative gate-level implementation (commented out)
    // AND gate implementation (balanced binary tree)
    wire and_stage1_0 = in[0] & in[1];
    wire and_stage1_1 = in[2] & in[3];
    assign out_and = and_stage1_0 & and_stage1_1;

    // OR gate implementation (balanced binary tree)
    wire or_stage1_0 = in[0] | in[1];
    wire or_stage1_1 = in[2] | in[3];
    assign out_or = or_stage1_0 | or_stage1_1;

    // XOR gate implementation (parity calculation)
    wire xor_stage1_0 = in[0] ^ in[1];
    wire xor_stage1_1 = in[2] ^ in[3];
    assign out_xor = xor_stage1_0 ^ xor_stage1_1;
    */

endmodule