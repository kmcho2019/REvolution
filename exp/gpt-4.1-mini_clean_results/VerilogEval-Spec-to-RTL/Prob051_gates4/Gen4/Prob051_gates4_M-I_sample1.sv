module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

wire and_ab, and_abc;
wire or_ab,  or_abc;
wire xor_ab, xor_abc;

// AND chain
and u_and_ab  (and_ab,  in[0], in[1]);
and u_and_abc (and_abc, and_ab, in[2]);
and u_and_out (out_and, and_abc, in[3]);

// OR chain
or  u_or_ab   (or_ab,   in[0], in[1]);
or  u_or_abc  (or_abc,  or_ab,  in[2]);
or  u_or_out  (out_or,  or_abc, in[3]);

// XOR chain
xor u_xor_ab  (xor_ab,  in[0], in[1]);
xor u_xor_abc (xor_abc, xor_ab, in[2]);
xor u_xor_out (out_xor, xor_abc, in[3]);

endmodule