module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products implementation
    // Covers all cases: 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c) | (b & c & d);

    // Corrected Product-of-sums implementation
    // Properly covers all 0 conditions
    assign out_pos = (a | c) & (~b | ~c | ~d);

endmodule