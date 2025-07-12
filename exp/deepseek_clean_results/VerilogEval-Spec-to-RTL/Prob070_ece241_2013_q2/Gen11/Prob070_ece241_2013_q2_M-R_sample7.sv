module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum of Products (SOP) form - minimal implementation
    // Covers cases 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) | (a & b & c);

    // Product of Sums (POS) form - minimal implementation
    // Covers inverse of cases where output is 0
    assign out_pos = (a | b | c) & (a | ~b | c) & (~a | b | ~c);

endmodule