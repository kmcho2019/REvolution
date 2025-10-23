module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Shared sub-expressions
    wire bcd = b & c & d;
    wire not_a = ~a;
    wire c_not_d = c & ~d;
    
    // SOP implementation using pattern matching
    assign out_sop = (not_a & c_not_d) |  // Covers 2 (0010)
                     bcd;                  // Covers 7 (0111) and 15 (1111)

    // POS implementation using complementary patterns
    wire a_not_b = a & ~b;
    wire not_a_not_c = not_a & ~c;
    assign out_pos = ~(a_not_b | not_a_not_c | 
                     (not_a & b & ~c & ~d) |  // Specific case for 4 (0100)
                     (a & ~b & c & ~d);       // Specific case for 10 (1010)

endmodule