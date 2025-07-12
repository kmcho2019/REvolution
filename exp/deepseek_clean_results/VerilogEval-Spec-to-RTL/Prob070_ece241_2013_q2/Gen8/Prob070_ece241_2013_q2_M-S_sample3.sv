module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (SOP)
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Product-of-Sums (POS)
    assign out_pos = c & (b | d) & (a | b | ~d);

endmodule