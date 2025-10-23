module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    // Minimum sum-of-products form for out_sop
    // Numbers 2 (0010), 7 (0111), and 15 (1111) should produce a logic-1
    assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimum product-of-sums form for out_pos
    // Numbers 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), and 14 (1110) should produce a logic-0
    // Hence, out_pos should be 1 for all other cases (i.e., 2, 3, 7, 8, 11, 12, 15)
    // However, we are given that 3, 8, 11, and 12 never occur, so we consider only 2, 7, and 15 for out_pos = 1
    // But, we need to ensure out_pos = 0 for the specified 0 cases, and since we can't directly use don't cares in POS, we must consider the complement of those cases directly
    assign out_pos = ~( (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (a & ~b & ~c & d) | (a & b & ~c & ~d) | (a & ~b & c & d) );
endmodule