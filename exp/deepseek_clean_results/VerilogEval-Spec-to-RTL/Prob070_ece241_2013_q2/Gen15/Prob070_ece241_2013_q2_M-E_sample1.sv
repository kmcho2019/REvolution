module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation using pattern matching
    assign out_sop = (~a & ~b & c & ~d) |  // Pattern for 2 (0010)
                     (~a & b & c & d) |     // Pattern for 7 (0111)
                     (a & b & c & d);       // Pattern for 15 (1111)

    // POS implementation using inverse pattern matching
    // Each term ensures we don't match any of the 0-cases
    assign out_pos = ~(~a & ~b & ~c & ~d) &  // Not matching 0 (0000)
                     ~(~a & ~b & ~c & d) &    // Not matching 1 (0001)
                     ~(~a & b & ~c & ~d) &    // Not matching 4 (0100)
                     ~(~a & b & ~c & d) &     // Not matching 5 (0101)
                     ~(~a & b & c & ~d) &     // Not matching 6 (0110)
                     ~(a & ~b & ~c & d) &     // Not matching 9 (1001)
                     ~(a & ~b & c & ~d) &     // Not matching 10 (1010)
                     ~(a & b & ~c & d) &     // Not matching 13 (1101)
                     ~(a & b & c & ~d);       // Not matching 14 (1110)

endmodule