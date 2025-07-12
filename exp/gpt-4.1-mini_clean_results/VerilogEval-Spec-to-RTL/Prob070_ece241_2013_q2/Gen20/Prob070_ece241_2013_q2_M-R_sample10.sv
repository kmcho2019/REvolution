module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] in = {a, b, c, d};

    // Minimal SOP for out_sop:
    // out_sop = m2 + m7 + m15
    // m2  =  0010 = ~a & ~b &  c & ~d
    // m7  =  0111 = ~a &  b &  c &  d
    // m15 = 1111 =  a &  b &  c &  d
    assign out_sop = 
        (~a & ~b &  c & ~d) |
        (~a &  b &  c &  d) |
        ( a &  b &  c &  d);

    // Minimal POS for out_pos:
    // out_pos is 0 for inputs: 0,1,4,5,6,9,10,13,14
    // Write out_pos as the product of sums for each zero (maxterms):
    // For example, maxterm for 0 (0000) is (a + b + c + d)
    // Write all maxterms and AND them.
    assign out_pos = 
        ( a |  b |  c |  d) &  // 0
        ( a |  b |  c | ~d) &  // 1
        ( a | ~b |  c |  d) &  // 4
        ( a | ~b |  c | ~d) &  // 5
        ( a | ~b | ~c |  d) &  // 6
        (~a |  b |  c | ~d) &  // 9
        (~a |  b | ~c |  d) &  // 10
        (~a | ~b |  c | ~d) &  // 13
        (~a | ~b | ~c |  d);   // 14

endmodule