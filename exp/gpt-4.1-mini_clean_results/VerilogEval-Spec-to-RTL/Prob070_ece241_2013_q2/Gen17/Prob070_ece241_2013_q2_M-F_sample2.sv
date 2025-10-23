module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-Products (SOP) for output = 1 at 2,7,15 with don't-cares at 3,8,11,12:
    // out_sop = (a & b) | (a & c & ~d) | (b & c & d)
    assign out_sop = (a & b) | (a & c & ~d) | (b & c & d);

    // Minimal Product-of-Sums (POS) for output = 1 at 2,7,15 with don't-cares at 3,8,11,12:
    // out_pos = (a + b + c) & (a + b + ~d) & (~a + b + ~c + ~d)
    assign out_pos = (a | b | c) & (a | b | ~d) & (~a | b | ~c | ~d);

endmodule