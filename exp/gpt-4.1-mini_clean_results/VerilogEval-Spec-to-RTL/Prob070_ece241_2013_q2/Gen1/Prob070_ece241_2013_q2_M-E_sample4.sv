module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [15:0] decoded;

    // Decode the 4-bit input into one-hot signals
    assign decoded[0]  = ~a & ~b & ~c & ~d;
    assign decoded[1]  = ~a & ~b & ~c &  d;
    assign decoded[2]  = ~a & ~b &  c & ~d;
    assign decoded[3]  = ~a & ~b &  c &  d; // never occurs
    assign decoded[4]  = ~a &  b & ~c & ~d;
    assign decoded[5]  = ~a &  b & ~c &  d;
    assign decoded[6]  = ~a &  b &  c & ~d;
    assign decoded[7]  = ~a &  b &  c &  d;
    assign decoded[8]  =  a & ~b & ~c & ~d; // never occurs
    assign decoded[9]  =  a & ~b & ~c &  d;
    assign decoded[10] =  a & ~b &  c & ~d;
    assign decoded[11] =  a & ~b &  c &  d; // never occurs
    assign decoded[12] =  a &  b & ~c & ~d; // never occurs
    assign decoded[13] =  a &  b & ~c &  d;
    assign decoded[14] =  a &  b &  c & ~d;
    assign decoded[15] =  a &  b &  c &  d;

    // Output is 1 for decimal 2,7,15
    assign out_sop = decoded[2] | decoded[7] | decoded[15];

    // Output is 0 for zeros at 0,1,4,5,6,9,10,13,14
    // So out_pos = 1 except when inputs correspond to these zeros.
    // Implement product-of-sums (POS) by combining maxterms of zeros
    assign out_pos = 
        (decoded[0]  | decoded[1]) &
        (decoded[4]  | decoded[5] | decoded[6]) &
        (decoded[9]  | decoded[10]) &
        (decoded[13] | decoded[14]);

    // Because out_pos is product of sums of zeros, it is 0 when any zero decoded is 1.
    // So final out_pos = ~(above), invert since POS is 1 for outputs=1, 0 for zeros.
    assign out_pos = ~(
        (decoded[0]  | decoded[1]) &
        (decoded[4]  | decoded[5] | decoded[6]) &
        (decoded[9]  | decoded[10]) &
        (decoded[13] | decoded[14])
    );

endmodule