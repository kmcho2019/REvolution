module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared intermediate signals for adjacent bits
    wire [2:0] adjacent_pairs = in[2:0] & in[3:1];
    wire [2:0] adjacent_ors = in[3:1] | in[2:0];

    // Optimized output assignments
    assign out_both = {1'b0, adjacent_pairs};  // out_both[3] is don't care
    assign out_any = {adjacent_ors, 1'b0};    // out_any[0] is don't care

    // Optimized XOR chain with wrap-around
    wire xor_10 = in[1] ^ in[0];
    wire xor_21 = in[2] ^ in[1];
    wire xor_32 = in[3] ^ in[2];
    assign out_different = {xor_32, xor_21, xor_10, in[0] ^ in[3]};

endmodule