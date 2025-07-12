module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Intermediate terms for readability
    wire abcd = a & b & c & d;       // 15
    wire abcd_n = ~a & b & c & d;    // 7
    wire a_nb_ncd_n = ~a & ~b & c & ~d; // 2

    // Sum-of-products implementation
    assign out_sop = abcd | abcd_n | a_nb_ncd_n;

    // Product-of-sums implementation (blocks invalid cases)
    assign out_pos = ~(
        (~a & ~b & ~c & ~d) |  // 0
        (~a & ~b & ~c & d)  |  // 1
        (~a & b & ~c & ~d) |  // 4
        (~a & b & ~c & d)   |  // 5
        (~a & b & c & ~d)   |  // 6
        (a & ~b & ~c & d)   |  // 9
        (a & ~b & ~c & ~d) |  // 10
        (a & b & ~c & d)    |  // 13
        (a & b & c & ~d)       // 14
    );

endmodule