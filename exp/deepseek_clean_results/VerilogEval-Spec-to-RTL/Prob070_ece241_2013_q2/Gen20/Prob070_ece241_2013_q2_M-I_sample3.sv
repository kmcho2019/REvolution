module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-Products form (only specified true cases)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                    (~a & b & c & d) |    // 7 (0111)
                    (a & b & c & d);      // 15 (1111)

    // Correct Product-of-Sums form
    // First create OR terms for false cases
    wire term0 = a | b | c | d;          // 0000
    wire term1 = a | b | c | ~d;         // 0001
    wire term4 = a | ~b | c | d;         // 0100
    wire term5 = a | ~b | c | ~d;        // 0101
    wire term6 = a | ~b | ~c | d;        // 0110
    wire term9 = ~a | b | c | ~d;        // 1001
    wire term10 = ~a | b | ~c | d;       // 1010
    wire term13 = ~a | ~b | c | ~d;      // 1101
    wire term14 = ~a | ~b | ~c | d;      // 1110

    // AND all the OR terms
    assign out_pos = term0 & term1 & term4 & term5 & 
                    term6 & term9 & term10 & term13 & term14;

endmodule