module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // SOP: Sum of minterms for decimal 2,7,15
    // 2 = 0 0 1 0 -> ~a & ~b &  c & ~d
    // 7 = 0 1 1 1 -> ~a &  b &  c &  d
    // 15= 1 1 1 1 ->  a &  b &  c &  d
    assign out_sop = 
          (~a & ~b &  c & ~d)
        | (~a &  b &  c &  d)
        | ( a &  b &  c &  d);

    // POS: Minimal product-of-sums considering zeros and don't cares
    // out_pos = (a + b + ~c + ~d) & (a + ~b + c + d) & (~a + b + c + d)
    assign out_pos = 
          (a | b | ~c | ~d)
        & (a | ~b | c | d)
        & (~a | b | c | d);

endmodule