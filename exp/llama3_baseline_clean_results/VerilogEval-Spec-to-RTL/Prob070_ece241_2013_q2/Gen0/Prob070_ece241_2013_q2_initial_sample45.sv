module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// The desired output is logic-1 for the binary representations of 2 (0010), 7 (0111), and 15 (1111)
assign out_sop = (a == 0 && b == 0 && c == 1 && d == 0) || // 0010
                 (a == 0 && b == 1 && c == 1 && d == 1) || // 0111
                 (a == 1 && b == 1 && c == 1 && d == 1);  // 1111

// Minimum product-of-sums form for out_pos
// The desired output is logic-0 for the binary representations of 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), and 14 (1110)
assign out_pos = !( (a == 0 && b == 0 && c == 0 && d == 0) || // 0000
                  (a == 0 && b == 0 && c == 0 && d == 1) || // 0001
                  (a == 0 && b == 1 && c == 0 && d == 0) || // 0100
                  (a == 0 && b == 1 && c == 0 && d == 1) || // 0101
                  (a == 0 && b == 1 && c == 1 && d == 0) || // 0110
                  (a == 1 && b == 0 && c == 0 && d == 1) || // 1001
                  (a == 1 && b == 0 && c == 1 && d == 0) || // 1010
                  (a == 1 && b == 1 && c == 0 && d == 1) || // 1101
                  (a == 1 && b == 1 && c == 1 && d == 0) ); // 1110

endmodule