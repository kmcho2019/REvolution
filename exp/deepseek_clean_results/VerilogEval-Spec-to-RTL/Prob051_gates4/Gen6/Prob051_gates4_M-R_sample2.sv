module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate wires for all operations
    wire and_result;
    wire or_result;
    wire xor_stage1, xor_stage2, xor_result;

    // All assignments in one block
    assign and_result = &in;
    assign or_result  = |in;
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = in[2] ^ in[3];
    assign xor_result = xor_stage1 ^ xor_stage2;

    // Final output assignments
    assign out_and = and_result;
    assign out_or  = or_result;
    assign out_xor = xor_result;

endmodule