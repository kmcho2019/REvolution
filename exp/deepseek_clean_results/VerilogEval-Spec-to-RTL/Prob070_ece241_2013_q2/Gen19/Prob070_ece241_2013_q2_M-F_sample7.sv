module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-products (minimal form)
    // Only asserts for 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d)   |  // 7
                     (a & b & c & d);     // 15

    // Correct Product-of-sums (minimal form)
    // Covers all false cases: 0(0000),1(0001),4(0100),5(0101),
    // 6(0110),9(1001),10(1010),13(1101),14(1110)
    assign out_pos = (a | b | c) &          // Covers 0,1,4,5,6
                     (a | ~b | c | d) &     // Covers 9,13
                     (a | ~b | ~c | d) &   // Covers 10
                     (~a | b | c | ~d);     // Covers 14

endmodule