module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (SOP) - covers 2,7,15
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Product-of-Sums (POS) - covers all 0 cases
    assign out_pos = c & (b | ~d) & (~b | d | a);

endmodule