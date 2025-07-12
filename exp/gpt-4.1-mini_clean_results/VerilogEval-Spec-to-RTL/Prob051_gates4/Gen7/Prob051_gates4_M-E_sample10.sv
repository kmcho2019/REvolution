module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// 4-input AND implemented as a two-level gate hierarchy
wire and_level1_0, and_level1_1;
and u_and0 (and_level1_0, in[0], in[1]);
and u_and1 (and_level1_1, in[2], in[3]);
and u_and_final (out_and, and_level1_0, and_level1_1);

// 4-input OR implemented as a two-level gate hierarchy
wire or_level1_0, or_level1_1;
or u_or0 (or_level1_0, in[0], in[1]);
or u_or1 (or_level1_1, in[2], in[3]);
or u_or_final (out_or, or_level1_0, or_level1_1);

// 4-input XOR implemented as a ripple XOR chain
wire xor_step1, xor_step2;
xor u_xor0 (xor_step1, in[0], in[1]);
xor u_xor1 (xor_step2, xor_step1, in[2]);
xor u_xor_final (out_xor, xor_step2, in[3]);

endmodule