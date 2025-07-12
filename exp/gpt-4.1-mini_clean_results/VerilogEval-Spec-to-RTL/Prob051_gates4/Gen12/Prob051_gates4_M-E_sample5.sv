module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

wire and_pair0, and_pair1;
wire or_pair0, or_pair1;
wire xor_pair0, xor_pair1;

// First stage: pairs
and and0(and_pair0, in[0], in[1]);
and and1(and_pair1, in[2], in[3]);

or  or0(or_pair0, in[0], in[1]);
or  or1(or_pair1, in[2], in[3]);

xor xor0(xor_pair0, in[0], in[1]);
xor xor1(xor_pair1, in[2], in[3]);

// Second stage: combine pairs
and and_final(out_and, and_pair0, and_pair1);
or  or_final(out_or, or_pair0, or_pair1);
xor xor_final(out_xor, xor_pair0, xor_pair1);

endmodule