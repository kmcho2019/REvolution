module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Combine inputs into 4-bit vector (a MSB, d LSB)
    wire [3:0] in_vec = {a, b, c, d};

    // Define constants for required inputs
    localparam [3:0] VAL_2  = 4'b0010;
    localparam [3:0] VAL_7  = 4'b0111;
    localparam [3:0] VAL_15 = 4'b1111;

    // SOP output: 1 if in_vec equals 2, 7, or 15
    assign out_sop = (in_vec == VAL_2) | (in_vec == VAL_7) | (in_vec == VAL_15);

    // For POS output, the zeros occur at: 0,1,4,5,6,9,10,13,14
    // Convert zero inputs to maxterms (a,b,c,d):
    // For maxterm, output is zero when all literals are zero, so maxterm = OR of input variables or their complements
    // Maxterm for zero input v: maxterm = (literal1 + literal2 + literal3 + literal4)
    // where literal is variable if bit is 0, complemented if bit is 1 (since maxterm zeros at that input)
    //
    // Define all zero inputs maxterms explicitly:
    // 0  = 0000 => (a + b + c + d)
    // 1  = 0001 => (a + b + c + ~d)
    // 4  = 0100 => (a + ~b + c + d)
    // 5  = 0101 => (a + ~b + c + ~d)
    // 6  = 0110 => (a + ~b + ~c + d)
    // 9  = 1001 => (~a + b + c + ~d)
    // 10 = 1010 => (~a + b + ~c + d)
    // 13 = 1101 => (~a + ~b + c + ~d)
    // 14 = 1110 => (~a + ~b + ~c + d)
    //
    // To implement POS, AND all these maxterms:
    // out_pos = (a + b + c + d) & (a + b + c + ~d) & (a + ~b + c + d) & (a + ~b + c + ~d) &
    //           (a + ~b + ~c + d) & (~a + b + c + ~d) & (~a + b + ~c + d) & (~a + ~b + c + ~d) &
    //           (~a + ~b + ~c + d)
    //
    // This is a large expression but guarantees exact coverage.
    //
    // Implement directly:

    assign out_pos = 
        (a | b | c | d) &
        (a | b | c | ~d) &
        (a | ~b | c | d) &
        (a | ~b | c | ~d) &
        (a | ~b | ~c | d) &
        (~a | b | c | ~d) &
        (~a | b | ~c | d) &
        (~a | ~b | c | ~d) &
        (~a | ~b | ~c | d);

endmodule