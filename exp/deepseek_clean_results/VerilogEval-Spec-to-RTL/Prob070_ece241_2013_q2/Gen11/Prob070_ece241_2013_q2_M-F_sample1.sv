module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal SOP form (OR of AND terms for 2,7,15)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Minimal POS form (AND of OR terms)
    // Derived by inverting the false cases (0,1,4,5,6,9,10,13,14)
    assign out_pos = (a | b | c | d) &      // Maxterm for 0 (0000)
                     (a | b | c | ~d) &     // Maxterm for 1 (0001)
                     (a | ~b | c | d) &    // Maxterm for 4 (0100)
                     (a | ~b | c | ~d) &    // Maxterm for 5 (0101)
                     (a | ~b | ~c | d) &    // Maxterm for 6 (0110)
                     (~a | b | c | ~d) &    // Maxterm for 9 (1001)
                     (~a | b | ~c | d) &    // Maxterm for 10 (1010)
                     (~a | ~b | c | ~d) &   // Maxterm for 13 (1101)
                     (~a | ~b | ~c | d);    // Maxterm for 14 (1110)

endmodule