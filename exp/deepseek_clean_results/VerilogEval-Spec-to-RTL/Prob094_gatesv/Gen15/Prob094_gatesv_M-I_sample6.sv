module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared XOR terms for out_different
    wire diff_3_2 = in[3] ^ in[2];
    wire diff_2_1 = in[2] ^ in[1];
    wire diff_1_0 = in[1] ^ in[0];
    wire diff_0_3 = in[0] ^ in[3];

    // out_both: Only compute needed bits (2:0)
    assign out_both = {1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any: Only compute needed bits (3:1)
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different: Use shared XOR terms
    assign out_different = {diff_0_3, diff_3_2, diff_2_1, diff_1_0};

endmodule