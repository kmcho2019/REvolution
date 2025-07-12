module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-Products (SOP) form implemented directly:
    // out_sop = (a & c & d) | (a & b & d) | (~a & b & ~c & d);
    assign out_sop = (a & c & d) | (a & b & d) | (~a & b & ~c & d);

    // Minimal Product-of-Sums (POS) form implemented directly:
    // out_pos = (a | b | ~d) & (a | ~b | c | d) & (~a | b | ~c | d);
    assign out_pos = (a | b | ~d) & (a | ~b | c | d) & (~a | b | ~c | d);

endmodule